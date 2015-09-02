# TODO :
#  - check if server already running, if yes reset
#  - dashed line around active chunk
#  - issue : correct bug in current tile, inconsistent state / view
#  - issue : multiple evaluation returning only last value
#  - force browser focus on bottom of current
#  - issue : reload on browser, resets the page

module Paper

    using Reexport
    @reexport using Escher

    using Compat
    using Mux
    using JSON

    using Reactive
    using Patchwork

    using Markdown
    import Compose
    # using Gadfly

    updated = Condition()
    active  = false

    function reset()
        global plan, torder, current

        plan    = Dict{Any, Vector{Tile}}()
        torder  = Any[]
        current = 0
        notify(updated) 
    end

    reset()

    include("server.jl")
    include("commands.jl")

    export build, init, chunk, reset

    function build()
        nbel = length(torder)
        if nbel==0 
            return title(1,"Ready...") |> 
                    pad(0.5em) |> borderwidth(1px) |> 
                    bordercolor("#444") |> borderstyle(dashed)
        else
            next = Array(Tile, length(torder))
            for (i,index) in enumerate(torder)
                els = length(plan[index]) == 0 ? vskip(0.5em) : vbox(plan[index]...)
                if index==current
                    els = els |> borderwidth(1px) |> bordercolor("#444") |> borderstyle(dashed)
                end
                next[i] = els
            end
            return vbox(next...) |> pad(0.5em)
        end
    end

    function init(port_hint=5555)
        global sock, serverid, active

        if active
            # should stop running tasks
            close(sock) 

            # should stop the server
            Base.throwto(serverid, InterruptException())
        end

        # App
        @app static = (
            Mux.defaults,
            route("assets", Mux.files(Pkg.dir("Escher", "assets")), Mux.notfound()),
            route("/", req -> setup_socket()),
            Mux.notfound(),
        )

        @app comm = (
            Mux.wdefaults,
            route("/socket/$thisStream", uisocket()),
            Mux.wclose,
            Mux.notfound(),
        )

        #find open port
        port, sock = listenany(port_hint)  
        close(sock)

        serverid = @async serve(static, comm, port)

        if !active  # open browser only if init called from inactive state
            fulladdr = "http://127.0.0.1:$port"
            @linux_only   run(`xdg-open $fulladdr`)
            @osx_only     run(`open $fulladdr`)
            @windows_only run(`cmd /c start $fulladdr`)
        end

        active = true
    end

end

