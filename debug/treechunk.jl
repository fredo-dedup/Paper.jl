
using Paper

@session tetstetsts



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
