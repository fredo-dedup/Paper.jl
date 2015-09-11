########################################################################################
#  Server setup
#   - mostly a copy of Escher's "src/cli/serve.jl"
########################################################################################

include(Pkg.dir("Escher", "src", "cli", "serve.jl"))

### specific socket definition for Paper's purpose
psocket() = (req) -> begin
    d = query_dict(req[:query])

    w = @compat parse(Int, d["w"])
    h = @compat parse(Int, d["h"])

    sock = req[:socket]
    tilestream = Input{Signal}(Input{Tile}(empty))

    # TODO: Initialize window with session,
    # window dimensions and what not

    window = Window(dimension=(w*px, h*px))

    # import by default
    write(sock, JSON.json(import_cmd("tex")))
    write(sock, JSON.json(import_cmd("widgets")))

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

### builds the Escher page structure
function build()
    nbel = length(torder)
    if nbel==0 
        return foldl(|>, 
                     title(1,"Ready...") |> borderwidth(1px) |> 
                     bordercolor("#444") |> borderstyle(dashed),
                     global_style)
    else
        next = Array(Tile, length(torder))
        for (i,index) in enumerate(torder)
            if length(plan[index]) == 0
                els = vbox(vskip(0.5em))
            else
                els = vbox(plan[index]...)
            end
            els = foldl(|>, els, chunk_style[index])

            if index==current
                els = els |> borderwidth(1px) |> bordercolor("#444") |> borderstyle(dashed)
            end

            next[i] = els
        end
        return foldl(|>, vbox(next...), global_style)
    end
end

### initializes the server
function init(port_hint=5555)
    global sock, serverid, active

    if active
        # should stop running tasks FIXME (doesn't work)
        close(sock) 

        # should stop the server (doesn't work)
        # Base.throwto(serverid, InterruptException())
    end

    # App
    @app static = (
        Mux.defaults,
        route("assets", Mux.files(Pkg.dir("Escher", "assets")), Mux.notfound()),
        route("/", req -> setup_socket("Paper")),
        Mux.notfound(),
    )

    @app comm = (
        Mux.wdefaults,
        route("/socket/Paper", psocket()),
        Mux.wclose,
        Mux.notfound(),
    )

    #find open port
    port, sock = listenany(port_hint) ; close(sock)

    serverid = @async serve(static, comm, port)

    if !active  # open browser only if init called from inactive state
        fulladdr = "http://127.0.0.1:$port"
        @linux_only   run(`xdg-open $fulladdr`)
        @osx_only     run(`open $fulladdr`)
        @windows_only run(`cmd /c start $fulladdr`)
    end

    active = true
end


