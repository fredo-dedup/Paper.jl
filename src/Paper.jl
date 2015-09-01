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
    plan    = Dict{Any, Vector{Tile}}()
    torder  = Any[]
    current = 0


    include("server.jl")
    include("commands.jl")



end

