# TODO :
# issue : check if server already running, if yes reset
# issue : multiple evaluation returning only last value
# add : force browser focus on bottom of current
# add : commands to load Escher assets
# alt : catch writemime calls, as if in debugging mode ? and use Signals...
# alt : lookup watch_io in stdio.jl
# add : Matplotlib Tiles - OK
# alt : Traits pour capter appels à writemime ?
# issue : pyplot showing multiple times, sometimes impossible to remove but with a F5
# issue : widget signal not caught


__precompile__(false)

module Paper

    using Compat
    using Reexport

    using Requires
    using Mux
    using JSON

    using Patchwork
    @reexport using Reactive
    @reexport using Escher

    import Compose

    updated  = Condition()  # doc updated signal

    serverid       = nothing      # server Task
    currentSession = nothing      # active session
    currentChunk   = nothing      # active chunk

    type Session
        chunks::Vector
        chunknames::Vector{Symbol}
        chunkstyles::Vector
        style::Vector
        window
    end
    Session()      = Session([], Symbol[], [],    [], nothing)
    Session(style) = Session([], Symbol[], [], style, nothing)

    sessions = Dict{Symbol, Session}()

    include("server.jl")
    include("commands.jl")
    # include("rewire.jl")
    include("redisplay.jl")

    export @chunk, @session, @rewire, @loadasset
    export stationary
    export writemime

end
