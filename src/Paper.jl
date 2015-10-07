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

    using Reexport
    @reexport using Escher

    using Compat
    using Mux
    using JSON

    @reexport using Reactive
    using Patchwork

    # using Markdown
    import Compose
    # using Gadfly

    updated  = Condition()  # doc updated signal
    active   = false        # server active ?
    sock     = nothing      # communication socket with server
    serverid = nothing      # server Task

    plan        = Dict()
    chunk_style = Dict() 
    torder  = Any[]
    current = 0
    global_style = Any[]

    include("server.jl")
    include("commands.jl")

    export init, chunk, reset, @chunk, @init


end

