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


    #-- Escher extension : add column layout function -------------------
    Escher.@api columns => (Columns <: Tile) begin
        doc("Set the number of columns.")
        arg(ncol::Int, doc="The number.")
        arg(gap::Escher.Length=1Escher.px, doc="The gap size between columns.")
        curry(tiles::Escher.TileList, doc="A tile or a vector of tiles.")
    end

    Escher.render(t::Columns, state) =
        Escher.wrapmany(t.tiles, :span, state) &
            Escher.style(Escher.@d(symbol("column-count")         => t.ncol,
                     symbol("-webkit-column-count") => t.ncol,
                     symbol("-moz-column-count")    => t.ncol,
                     symbol("column-gap")           => t.gap,
                     symbol("-webkit-column-gap")   => t.gap,
                     symbol("-moz-column-gap")      => t.gap))

    export columns

    export @newchunk, @tochunk, @session, @loadasset
    export @rewire, rewire, isrewired
    export stationary, compile
    export show
end
