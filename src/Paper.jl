# TODO :
# issue : check if server already running, if yes reset
# issue : multiple evaluation returning only last value
# add : force browser focus on bottom of current
# add : commands to load Escher assets
# alt : catch writemime calls, as if in debugging mode ? and use Signals...
# alt : lookup watch_io in stdio.jl
# add : Matplotlib Tiles
# alt : Traits pour capter appels à writemime

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
    end
    Session()      = Session([], Symbol[], [],    [])
    Session(style) = Session([], Symbol[], [], style)

    sessions = Dict{Symbol, Session}()

    include("server.jl")
    include("commands.jl")
    include("rewire.jl")

    export @chunk, @session, @rewire
    export stationary


end

