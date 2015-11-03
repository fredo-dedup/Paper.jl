# ideas :
# alt : catch writemime calls, as if in debugging mode ? and use Signals...
# alt : lookup watch_io in stdio.jl
# alt : Traits pour capter appels à writemime ?

# new func :
# add : force browser focus on bottom of current
# add : command to switch to another session
# add : tree struct for chunks, referenced like a file struct

# issues :
# issue : check if server already running, if yes reset
# issue : multiple evaluation returning only last value
# issue : pyplot showing multiple times, sometimes impossible to remove but with a F5
# issue : widget signal not caught
# issue : all text output caught and not shown

# DONE :
# add : Matplotlib Tiles - OK
# add : commands to load Escher assets - OK

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


    include("chunk.jl")
    include("session.jl")

    serverid       = nothing      # server Task

    include("server.jl")
    # include("commands.jl")
    # include("rewire.jl")
    include("redisplay.jl")

    export @newchunk, @tochunk, @session, @rewire, @loadasset, rewire
    export stationary
    # export writemime


    import Base.show
    const indent = 2
    function show(io::IO, s::Session)
       show(s.rootchunk)

    end

    function show(io::IO, c::Chunk; indent=0)
       spad = " " #^ indent
       println(io, spad, "$(c.name) ($(length(c.children)) elements) : ")
       for e in c.children
           if isa(e, Chunk)
               show(io, e, indent=indent+2)
           else
               println(io, spad, "  - ", typeof(e))
           end
       end
    end

    export show
end
