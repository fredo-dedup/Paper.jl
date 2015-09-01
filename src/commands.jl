############ user commands ##################

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

    


    # rewire(TT) do v
    #     println("he ho !")
    # end

    # TT(1)
    # methods(rewire, (MIME"text/plain"(), TT, Function))
    # type TT2
    #     x
    # end
    # a = TT2(3)
    # mm = methods(writemime, (IO, MIME, TT2))[1]
    # a
    # myfunc(a)
    # myfunc(x) = println("x: $(x.x)")
    # rewire(MIME"text/plain", TT2, myfunc)
    # TT(1)
    # meth = methods(writemime, (IO, MIME"text/plain", TT))[1].func
    # TT(1)
    # rewire(MIME"text/plain", Int64, sin)
    # MIME"text/plain" <: MIME
    # typeof(MIME"text/plain"())
    # res = methods(writemime, (IO, MIME"text/plain", Int64))
    # eltype(res)
    # typeof(res[1])
    # typeof(res[1].func)
    # res[1].func
    # MIME
    # isa(Int64, Type)
    # isa(MIME"text/plain", MIME)
    # isa(MIME"text/plain"(), MIME)
    # isa(MIME"text/plain", Type{MIME})
    # typeof(MIME"text/plain"())
    # @rewire MIME"text/plain" abcd
    # @rewire Int64 abcd
    # macro www2(x::MIME)
    #     println(typeof(x))    
    # end
    # @www MIME"text/plain"
    # @www x -> addtochunk(x)
    # @www2 MIME"text/plain"
    # @www Any



