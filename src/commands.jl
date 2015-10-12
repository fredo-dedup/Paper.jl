############ user commands ##################

# function reset()
#     global plan, torder, current

#     plan    = Dict()
#     torder  = Any[]
#     current = 0
#     chunk_style = Dict()
#     notify(updated) 
# end


function chunk(name, pos=0)
    global plan, current, torder

    currentSession==nothing && error("No active session yet")

    

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
    plan[index] = []
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
    plan[index] = []
    notify(updated)
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

function addtochunk(t)
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
    rewire(t::Type)                 = rewire(addtochunk, MIME"text/plain", t)

    rewire(String)
    rewire(Number)
    rewire(Markdown.MD)
    rewire(Tile)
    rewire(Compose.Context)
