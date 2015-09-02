########################################################################################
#  Server setup
#   - mostly a copy of Escher's "src/cli/serve.jl"
########################################################################################

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
    tilestream = Input{Signal}(Input{Tile}(build()))

    # TODO: Initialize window with session,
    # window dimensions and what not

    window = Window(dimension=(w*px, h*px))

    # import by default
    write(sock, JSON.json(import_cmd("tex")))
    lift(asset -> write(sock, JSON.json(import_cmd(asset))),
         window.assets)

    newstream = nothing
    try
        newstream = build()
    catch err
        bt = backtrace()
        newstream = Elem(:pre, sprint() do io
            showerror(io, err)
            Base.show_backtrace(io, bt)
        end)
    end
    swap!(tilestream, newstream)

    start_updates(flatten(tilestream, typ=Any), window, sock, "root")

    # client commands processing ?
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
        swap!(tilestream, build())
    end
end

# function launch(port_hint=5555)
#     # App
#     @app static = (
#         Mux.defaults,
#         route("assets", Mux.files(Pkg.dir("Escher", "assets")), Mux.notfound()),
#         route("/", req -> setup_socket()),
#         Mux.notfound(),
#     )

#     @app comm = (
#         Mux.wdefaults,
#         route("/socket/$thisStream", uisocket()),
#         Mux.wclose,
#         Mux.notfound(),
#     )

#     port, sock = listenany(port_hint)  #find open port
#     close(sock)

#     tid = @async serve(static, comm, port)

#     fulladdr = "http://127.0.0.1:$port"
#     @linux_only   run(`xdg-open $fulladdr`)
#     @osx_only     run(`open $fulladdr`)
#     @windows_only run(`cmd /c start $fulladdr`)

#     tid
# end


