########### writemime rewiring #################

import Base.Multimedia.writemime

const currentTask = current_task()

# methods(writemime, (IO, MIME"text/plain", Float64))

function rewire{T<:MIME}(func::Function, mt::Type{T}, t::Type)
    if method_exists(writemime, (IO, mt, t))
        meth = methods(writemime, (IO, mt, t))[1].func
        ex = quote 
                function writemime(io::IO, mt::$mt, x::$t)
                    # println("$io,   $(io==STDOUT))")
                    # println("interact : $(isinteractive())")
                    # println("task : $(current_task())")
                    current_task()==currentTask && ($func)(x) # send only if interactive task
                    ($meth)(io, mt, x)
                end 
             end
    else
        ex = quote
                function writemime(io::IO, mt::$mt, x::$t) 
                    current_task()==currentTask && ($func)(x)
                end
             end
    end
    # println(ex)
    eval(ex)
end

rewire(func::Function, t::Type) = rewire(func,       MIME"text/plain", t)
rewire(t::Type)                 = rewire(addtochunk, MIME"text/plain", t)

macro rewire(args...)
    for a in args
        try
            t = eval(a)
            if isa(t, Type)
                rewire(t)
            else
                warn("$a does not evaluate to a type")
            end
        catch e
            warn("can't evaluate $a, error $e")
        end
    end
end


@rewire AbstractString Number Base.Markdown.MD Tile
# rewire(String)
# rewire(Number)
# rewire(Markdown.MD)
# rewire(Tile)
# rewire(Compose.Context)