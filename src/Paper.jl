# ideas :
# alt : catch writemime calls, as if in debugging mode ? and use Signals...
# alt : Traits pour capter appels à writemime ?

# new func :
# add : interactive mode for the REPL
# add : force browser focus on bottom of current
# add : command to switch to another session

# issues :
# issue : widget signal not caught, workaround @loadasset "widgets"
# issue : pyplot showing multiple times, sometimes impossible to remove but with a F5

# DONE :
# issue : check if server already running - OK
# add : tree struct for chunks, referenced like a file struct - OK
# add : Matplotlib Tiles - OK
# add : commands to load Escher assets - OK
# add : compile func

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

    import Base.show

    include("chunk.jl")
    include("session.jl")

    include("server.jl")
    include("redisplay.jl")
    include("compile.jl")

    serverid = nothing      # server Task

    export @newchunk, @tochunk, @session, @loadasset
    export @rewire, rewire, isrewired
    export stationary, compile
    export show
end
