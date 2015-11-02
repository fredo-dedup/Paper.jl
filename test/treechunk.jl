
module Tree ; end

module tree
type Chunk
  name::AbstractString
  children::Vector
  parent::Nullable{Chunk}
  styling::Function
end
Chunk() = Chunk(string(gensym("chunk")))
Chunk(style::Function) = Chunk(string(gensym("chunk")), style)
Chunk(name::AbstractString) = Chunk(name, vcat) # vertical layout default
Chunk(n::AbstractString, st::Function) =
  Chunk(n, Any[], Nullable{Chunk}(), st)

function findelem(ns::Vector, startelem::Chunk)
  for e in startelem.children
    e.name == ns[1] && return length(ns)==1 ? e : findelem(ns[2:end], e)
  end
  return nothing
end


root = Chunk("root")
push!(root.children, Chunk("abcd"))
push!(root.children, Chunk("xyz"))
nc = Chunk("www")
push!(root.children, nc)
push!(nc.children, Chunk("end"))

findelem(["end"], nc)
findelem(["end2"], nc)
findelem(["end2"], root)
findelem(["abcd"], root)
findelem(["www"], root)
findelem(["www", "end"], root)
findelem(["www", "end2"], root)

end



using ReverseDiffSource

function getW33(k)
    sqrt2l = sqrt(2.0)
    t2 = k*k
    t3 = acos(t2 - 1.0)
    t4 = 2.0 - t2
    t6 = 2*π - t3
    t5 = 1.0/t4
    (t6 * sqrt(t5) - k)*t5
end

dapprox(f, x, ϵ=1e-8) = (f(x+ϵ)-f(x)) / ϵ

dapprox(getW33, -0.5)

@deriv_rule acos(x::Real) x -ds / sqrt(1-x*x)
dg = rdiff(getW33, (1.,), allorders=false)
dg(-0.5)


i = 1
exfun = quote
  tmp = [x[2],x[1]]
  tmp[i]
end

i = 1 # i needs to set for rdiff to work
dex = rdiff(exfun, x=ones(2))

dfun2(ones(2))

vect

@eval function mex(x)
        res = Array(Float64, length(x), length(x)) # will hold the result
        for i in 1:length(x)
          _ , res[i,:] = $dex
        end
        res
      end

mex([0.,1])



function fun2(x)
  tmp = [x[2];x[1]]
  tmp[i]
end

fun2(ones(2))

i = 1 # i needs to set for rdiff to work
dfun2 = rdiff(fun2, ([0.,1],))

dfun2(ones(2))

i = 1
fun2([0., 1])
dfun2([0., 1])
i = 2
fun2([0., 1])
dfun2([0., 1])


function mdfun2(x)
  global i
  res = Array(Float64, 2, 2) # will hold the result
  i = 1
  _, res[1,:] = dfun2(x)
  i = 2
  _, res[2,:] = dfun2(x)
  res
end


mdfun2(zeros(2))


@eval function mex(x)
        res = Array(Float64, length(x), length(x)) # will hold the result
        for i in 1:length(x)
          _ , res[i,:] = $dex
        end
        res
      end

mex(ones(3))
