########################################################################################
#  Server setup
#   - mostly a copy of Escher's "src/cli/serve.jl"
########################################################################################

include(Pkg.dir("Escher", "src", "cli", "serve.jl"))

### specific socket definition for Paper's purpose
function uisocket(req)
    sn = req[:params][:session] # session name
    println("session = $sn")
    session = sessions[symbol(sn)]

    d = query_dict(req[:query])

    w = @compat parse(Int, d["w"])
    h = @compat parse(Int, d["h"])

    sock = req[:socket]
    println("sock = $sock")
    tilestream = Input{Signal}(Input{Tile}(empty))

    # TODO: Initialize window with session,
    # window dimensions and what not

    window = Window(dimension=(w*px, h*px))

    # import by default
    write(sock, JSON.json(import_cmd("tex")))
    write(sock, JSON.json(import_cmd("widgets")))

    lift(asset -> write(sock, JSON.json(import_cmd(asset))),
         window.assets)

    newstream = Escher.empty
    try
        newstream = build(session)
    catch err
        # bt = backtrace()
        # str = sprint() do io
        #     showerror(io, err)
        #     Base.show_backtrace(io, bt)
        # end
        str = string(err)
        newstream = Elem(:pre, str )
        # println( str )
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
        newstream = try
                        build(session)
                    catch err
                        # bt = backtrace()
                        # str = sprint() do io
                        #     showerror(io, err)
                        #     Base.show_backtrace(io, bt)
                        # end
                        # println( str )
                        str = string(err)
                        Elem(:pre, str )
                    end
        swap!(tilestream, newstream())
    end
end

### builds the Escher page structure
function build(session::Session)
    # session = p.sessions[:lmno]
    nbel = length(session.chunks)
    println("build, nbel = $nbel")
    if nbel==0 
        # return foldl(|>, 
        #              title(1,"Ready...") |> borderwidth(1px) |> 
        #              bordercolor("#444") |> borderstyle(dashed),
        #              session.style)
        return title(1,"Ready...") |> borderwidth(1px) |> 
                     bordercolor("#444") |> borderstyle(dashed)
    end

    next = Array(Tile, nbel)
    # for (i,index) in enumerate(session.chunknames)
    for i in 1:nbel
        # println(i, "  ", index)
        # idx = indexin([index])
        if length(session.chunks[i]) == 0
            els = vskip(0.5em)
        else
            els = vbox(session.chunks[i])
        end
        # els = foldl(|>, els, session.chunkstyles[i])

        #if session.chunks[i]==currentChunk
        #    els = els |> borderwidth(1px) |> bordercolor("#444") |> borderstyle(dashed)
        #end

        next[i] = els
    end
    # return foldl(|>, vbox(next...), session.style)
    vbox(next...)
end

### initializes the server
function init(port_hint=5555)
    global sock, serverid, active, port

    println("init")

    # App
    @app static = (
        Mux.defaults,
        route("pkg/:pkg", packagefiles("assets"), Mux.notfound()),
        route("assets", Mux.files(Pkg.dir("Escher", "assets")), Mux.notfound()),
        # route("assets", Mux.files(dir), Mux.notfound()),
        route("/:session", req -> setup_socket(req[:params][:session]) ),
        route("/", req -> setup_socket("Paper")),
        Mux.notfound(),
    )


    @app comm = (
        Mux.wdefaults,
        route("/socket/:session", uisocket),
        Mux.wclose,
        Mux.notfound(),
    )





    #find open port
    port, sock = listenany(port_hint) ; close(sock)
    serverid = @async serve(static, comm, port)

    active = true
end


macro restart_server()
end

# macro session() 
#     @session(gensym("session"))
# end

macro session(name::Symbol)
    global currentSession, currentChunk

    haskey(sessions, name) && error("There is already a session '$name'")

    newsession = Session()
    sessions[name] = newsession
    currentSession = newsession
    currentChunk   = nothing
    
    fulladdr = "http://127.0.0.1:$port/$name"
    @linux_only   run(`xdg-open $fulladdr`)
    @osx_only     run(`open $fulladdr`)
    @windows_only run(`cmd /c start $fulladdr`)
end

# macro close_session(name::Symbol=currentSession)
# end
