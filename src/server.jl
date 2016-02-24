########################################################################################
#  Server setup
#   - mostly a copy of Escher's "src/cli/serve.jl"
########################################################################################

include(Pkg.dir("Escher", "src", "cli", "serve.jl"))

### specific socket definition for Paper's purpose
function uisocket(req)
    sn = req[:params][:session] # session name
    println("session : $sn ($(typeof(sn)))  => $(symbol(sn))")
    session = sessions[string(sn)]

    d = query_dict(req[:query])

    w = @compat parse(Int, d["w"])
    h = @compat parse(Int, d["h"])

    sock = req[:socket]
    tilestream = Signal(Signal, Signal(Tile, empty))

    window = Window(dimension=(w*px, h*px))
    session.window = window

    # import by default
    # write(sock, JSON.json(import_cmd("tex")))
    # write(sock, JSON.json(import_cmd("widgets")))

    foreach(asset -> write(sock, JSON.json(import_cmd(asset))),
         window.assets)

    newstream = build(session)
    swap!(tilestream, newstream)

    start_updates(flatten(tilestream, typ=Any), window, sock, "root")

    # client commands processing ?
    t = @async while isopen(sock)
        try
            data = read(sock)
            msg = JSON.parse(bytestring(data))
            if !haskey(commands, msg["command"])
                warn("Unknown command received ", msg["command"])
            else
                commands[msg["command"]](window, msg)
            end
        catch
            error("\nError while reading from websocket, closing session $sn")
        end
    end

    while isopen(sock)
        wait(session.updated)
        newstream = build(session)
        try
            swap!(tilestream, newstream)
        catch err
            error("\nError while updating, closing session $sn")
        end
    end
    wait(t)
end

# real_update = Condition()

### initializes the server
function init(port_hint=5555)
    global serverid, port

    println("init")

    # App
    @app static = (
        Mux.defaults,
        route("pkg/:pkg", packagefiles("assets"), Mux.notfound()),
        route("assets", Mux.files(Pkg.dir("Escher", "assets")), Mux.notfound()),
        route("/:session", req -> setup_socket(req[:params][:session]) ),
        # route("/", req -> setup_socket("Paper")),
        Mux.notfound(),
    )

    @app comm = (
        Mux.wdefaults,
        route("/socket/:session", uisocket),
        Mux.wclose,
        Mux.notfound(),
    )

    #find open port
    port, sock = listenany(port_hint) # find an available port
    close(sock)
    serverid = @async serve(static, comm, port)
end

macro loadasset(args...)
    currentSession == nothing && error("No session active yet, run @session")
    isdefined(Paper.currentSession, :window) || sleep(1.) # give time if needed
    isdefined(Paper.currentSession, :window) || sleep(1.) # give time if needed
    isdefined(Paper.currentSession, :window) || sleep(1.) # give time if needed
    isdefined(Paper.currentSession, :window) || sleep(1.) # give time if needed
    isdefined(Paper.currentSession, :window) || error("No window for this session yet")

    for a in args
        if isa(a, AbstractString)
            push!(currentSession.window.assets, a)
        else
            warn("$a is not a string")
        end
    end
end
