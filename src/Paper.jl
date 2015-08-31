module Paper

    using Escher

    using Compat
    using Mux
    using JSON

    using Reactive
    using Patchwork

    const thisStream = "Paper"

    function setup_socket()
        io = IOBuffer()
        write(io, """<!doctype html>
        <html>
            <head>
            <meta charset="utf-8">
            """)
        # Include the basics
        write(io, "<script>", Patchwork.js_runtime(), "</script>")
        write(io, """<script src="/assets/bower_components/webcomponentsjs/webcomponents.min.js"></script>""")
        write(io, """<link rel="import" href="$(Escher.resolve_asset("basics"))">""")

        write(io, """</head> <body fullbleed unresolved>""")
        write(io, """<script>window.addEventListener('polymer-ready', function(e) {
              Escher.init($(JSON.json(thisStream)));
        })</script>
        <signal-container id="root"></signal-container>
        </body>
        </html>""")
        takebuf_string(io)
    end

    mount_cmd(node, id="root") =
       [ "command" => "mount",
        "id" => id,
        "data" => Patchwork.jsonfmt(node)] |> JSON.json

    import_cmd(asset) =
        [ "command" => "import",
          "data" => Escher.resolve_asset(asset) ] 

    patch_cmd(id, diff) =
       [ "command" => "patch",
        "id" => id,
        "data" => Patchwork.jsonfmt(diff)] |> JSON.json

    swap!(tilestream, next::Signal) = push!(tilestream, next)

    swap!(tilestream, next) = push!(tilestream, Input(next))

    const signals = Dict()
    function Escher.setup_transport(x::Tuple)
        Escher.makeid(x)
    end

    const commands = Dict([
        ("signal-update", (window, msg) -> begin
            id = msg["data"]["signalId"]
            interp, sig = Escher.fromid(id)
            push!(sig, Escher.interpret(interp, msg["data"]["value"]))
        end),
        ("window-size", (window, msg) -> begin
            dim = (msg["data"][1] * Escher.px, msg["data"][2] * Escher.px)
            push!(window.dimension, dim)
        end),
        ("window-route", (window, msg) -> begin
            push!(window.route, msg["data"])
        end),
        ("window-kill", (window, msg) -> begin
            push!(window.alive, false)
        end),
    ])

    query_dict(qstr) = begin
        parts = split(qstr, '&')
        dict = Dict()
        for p in parts
            k, v = split(p, "=")
            dict[k] = v
        end
        dict
    end

    start_updates(sig, window, sock, id=Escher.makeid(sig)) = begin
        state = Dict()
        state["embedded_signals"] = Dict()
        init = render(value(sig), state)

        write(sock, patch_cmd(id, Patchwork.diff(render(Escher.empty, state), init)))

        foldl(init, keepwhen(window.alive, Escher.empty, sig); typ=Any) do prev, next

            st = Dict()
            st["embedded_signals"] = Dict()
            rendered_next = render(next, st)

            try
                write(sock, patch_cmd(id, Patchwork.diff(prev, rendered_next)))
            catch ex
                if isopen(sock)
                    rethrow(ex)
                end
            end
            for (key, sig) in st["embedded_signals"]
                start_updates(sig, window, sock, key) 
            end

            rendered_next
        end

        for (key, sig) in state["embedded_signals"]
            start_updates(sig, window, sock, key) 
        end
    end


    uisocket() = (req) -> begin
        d = query_dict(req[:query])

        w = @compat parse(Int, d["w"])
        h = @compat parse(Int, d["h"])

        sock = req[:socket]
        tilestream = Input{Signal}(Input{Tile}(empty))

        # TODO: Initialize window with session,
        # window dimensions and what not

        window = Window(dimension=(w*px, h*px))

        lift(asset -> write(sock, JSON.json(import_cmd(asset))),
             window.assets)

        current = Escher.empty
        try
            current = vbox("Starting up...")
        catch err
            bt = backtrace()
            current = Elem(:pre, sprint() do io
                showerror(io, err)
                Base.show_backtrace(io, bt)
            end)
        end

        swap!(tilestream, current)

        start_updates(flatten(tilestream, typ=Any), window, sock, "root")

        @async while isopen(sock)
            data = read(sock)

            msg = JSON.parse(bytestring(data))
            if !haskey(commands, msg["command"])
                warn("Unknown command received ", msg["command"])
            else
                commands[msg["command"]](window, msg)
            end
        end

        while isopen(sock)
            wait(updated)
            sleep(0.05)

            next = Tile[]
            for index in torder
                els = length(plan[index]) == 0 ? Escher.empty : vbox(plan[index]...)
                push!(next, els |> borderwidth(1px) |> bordercolor("#444") |> borderstyle(solid) )
            end
            # next = mytiles
            swap!(tilestream, vbox(next...))
        end
    end

    updated = Condition()
    plan    = Dict{Any, Vector{Tile}}()
    torder  = Any[]
    current = 0

    function launch(port=5555)
        # App
        @app static = (
            Mux.defaults,
            route("assets", Mux.files(Pkg.dir("Escher", "assets")), Mux.notfound()),
            route("/", req -> setup_socket()),
            Mux.notfound(),
        )

        @app comm = (
            Mux.wdefaults,
            route("/socket/$thisStream", uisocket("")),
            Mux.wclose,
            Mux.notfound(),
        )

        @sync serve(static, comm, port)
    end

    function chunk(index, pos=0)
        global plan, current, torder

        if length(torder)==0
            push!(torder, index)
        elseif !haskey(plan, index) # new index
            if pos in 1:length(torder)
                insert!(torder, pos, index)
            else
                push!(torder, index)
            end
        end
        current = index
        plan[index] = Tile[]
        notify(updated)
    end

    function addtochunk(t)
        length(torder)==0 && return
        push!(plan[current], t)
        notify(updated) 
    end


    import Base.Multimedia.writemime

    # methods(writemime, (IO, MIME"text/plain", Float64))

    function writemime(io::IO, ::MIME"text/plain", x)
        try
            addtochunk(x)
        catch e
            println(e)
        end
        Base.showlimited(io, x)
    end


end

