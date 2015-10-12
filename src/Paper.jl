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
    active   = false        # server active ?
    sock     = nothing      # communication socket with server
    serverid = nothing      # server Task
    currentSession = nothing
    currentChunk   = nothing

    type Session
        style
        chunks::Vector
        chunknames::Vector{Symbol}
        chunkstyles::Vector
    end
    Session() = Session(nothing, [], Symbol[], [])

    sessions = Dict{Symbol, Session}()

    # plan        = Dict()
    # chunk_style = Dict() 
    # torder  = Any[]
    # current = 0
    # global_style = Any[]

    include("server.jl")
    include("commands.jl")

    export init, chunk, reset, @chunk, @init


end

