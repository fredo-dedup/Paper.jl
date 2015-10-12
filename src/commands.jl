############ user commands ##################

function chunk(name, pos=0)
    global currentChunk

    currentSession==nothing && error("No active session yet")

    if name in currentSession.chunknames # replace existing chunk
        index = indexin([name], currentSession.chunknames)[1]
        currentSession.chunks[index] = []
        currentSession.chunkstyles[index] = []
        currentChunk = currentSession.chunks[index]
    else
        push!(currentSession.chunknames, name)
        push!(currentSession.chunks,       [])    
        push!(currentSession.chunkstyles,  [])    
        currentChunk = currentSession.chunks[end]
    end

    notify(updated)
end

macro chunk(args...)
    chunk(args[1])
end
# macro chunk(index, args...)
#     global chunk_style

#     haskey(chunk_style, index) || ( chunk_style[index]=Any[] ) 
#     for a in args
#         try
#             push!(chunk_style[index], eval(a))
#         catch e
#             warn("can't evaluate $a, error $e")
#         end
#     end

#     chunk(index)
# end

function addtochunk(t)
    if currentSession==nothing
        println("No active session yet")
        return
    elseif currentChunk==nothing
        println("No active chunk yet, run @chunk")
        return
    end
    push!(currentChunk, t)
    notify(updated) 
end

function stationary(f::Function, signals::Signal...)
    st = lift(f, signals...)
    addtochunk(empty)
    ch   = currentChunk
    slot = length(plan[current]) 
    lift(st) do nt
        ch[slot] = nt
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

    # rewire(String)
    # rewire(Number)
    # rewire(Markdown.MD)
    # rewire(Tile)
    # rewire(Compose.Context)
