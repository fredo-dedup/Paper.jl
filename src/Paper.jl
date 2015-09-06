# TODO :
#  - issue : check if server already running, if yes reset
#  - issue : multiple evaluation returning only last value
#  - new : force browser focus on bottom of current
#  - new : commands to load Escher assets


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

    updated  = Condition()  # doc updated flag
    active   = false        # server active ?
    sock     = nothing      # communication socket with server
    serverid = nothing      # server Task

    plan        = Dict{Any, Vector{Tile}}()
    chunk_style = Dict() 
    torder  = Any[]
    current = 0
    global_style = Any[]

    include("server.jl")
    include("commands.jl")

    export init, chunk, reset, @chunk, @init


end

