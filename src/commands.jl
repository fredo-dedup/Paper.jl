############ user commands ##################

function reset()
    global plan, torder, current

    plan    = Dict{Any, Vector{Tile}}()
    torder  = Any[]
    current = 0
    chunk_style = Dict()
    notify(updated) 
end

function chunk(index, pos=0)
    global plan, current, torder

    if length(torder)==0
        push!(torder, index)
    elseif !haskey(plan, index) # new index
        if pos in 1:length(torder)
            insert!(torder, pos, index)
        else
            push!(torder, index)
        end
    end
    current = index
    plan[index] = Tile[]
    notify(updated)
end

function addtochunk(t::Tile)
    length(torder)==0 && return
    push!(plan[current], t)
    notify(updated) 
end

function stationary(f::Function, signals::Signal...)
    st = lift(f, signals...)
    addtochunk(empty)
    pos1 = current
    pos2 = length(plan[current]) 
    lift(st) do nt
        plan[pos1][pos2] = nt
        notify(updated)
    end
end

macro chunk(index, args...)
    global chunk_style

    haskey(chunk_style, index) || ( chunk_style[index]=Any[] ) 
    for a in args
        try
            push!(chunk_style[index], eval(a))
        catch e
            warn("can't evaluate $a, error $e")
        end
    end

    chunk(index)
end

macro init(args...)
    global global_style

    global_style = Any[] 
    for a in args
        try
            push!(global_style, eval(a))
        catch e
            warning("can't evaluate $a")
        end
    end

    init()
end

########### writemime rewiring #################

    import Base.Multimedia.writemime

    # methods(writemime, (IO, MIME"text/plain", Float64))

    function rewire{T<:MIME}(func::Function, mt::Type{T}, t::Type)
        if method_exists(writemime, (IO, mt, t))
            meth = methods(writemime, (IO, mt, t))[1].func
            ex = quote 
                    function writemime(io::IO, mt::$mt, x::$t)
                        ($func)(x)
                        ($meth)(io, mt, x)
                    end 
                 end
        else
            ex = quote
                    writemime(io::IO, mt::$mt, x::$t) = ($func)(x)
                 end
        end
        # println(ex)
        eval(ex)
    end

    rewire(func::Function, t::Type) = rewire(func, MIME"text/plain", t)


    rewire(String) do s
        addtochunk(convert(Tile, s))
    end

    rewire(Number) do x
        addtochunk(convert(Tile, string(x)))
    end

    rewire(Markdown.MD) do m
        addtochunk(convert(Tile, m))
    end

    rewire(Tile) do t
        addtochunk(t)
    end

    rewire(Compose.Context) do c
        addtochunk(convert(Tile, c))
    end




