#########################################################
#  Chunk defs and functions
#########################################################

######## The Chunk type #########

type Chunk
  name::AbstractString
  children::Vector
  parent::Nullable{Chunk}
  styling::Function
end
Chunk() = Chunk(string(gensym("chunk")))
Chunk(style::Function) = Chunk(string(gensym("chunk")), style)
Chunk(name::AbstractString) = Chunk(name, vbox) # vertical layout default
Chunk(n::AbstractString, st::Function) =
  Chunk(n, Any[], Nullable{Chunk}(), st)


currentChunk   = nothing      # no active chunk at startup

######### Chunk find / create functions #####




############ user commands ##################

# finds the chunk at path specified in ns
# ns = [:abcd;] ; startelem = parentChunk
function findelem(ns::Vector, startelem::Chunk=currentSession.rootchunk)
  for e in startelem.children
    isa(e, Chunk) || continue
    e.name == ns[1] && return length(ns)==1 ? e : findelem(ns[2:end], e)
  end
  return nothing
end

# splits an expression such as :(abcd.def) in [:acd, :def]
function esplit(ex)
  isa(ex, QuoteNode) && return [ex.value;]
  isa(ex, Symbol)    && return [ex;]
  isa(ex, Expr)      || error("format")

  ex.head == :. && return [esplit(ex.args[1]); esplit(ex.args[2])]
  ex.head == :quote && return [ex.args[1];]

  error("format")
end


macro tochunk(path)
    global currentChunk

    cp = try
            esplit(path)
         catch
            error("not a valid path")
         end
    ns = findelem(cp)
    ns == nothing && error("chunk $path not found")

    currentChunk = ns
end

macro newchunk(path, styling...) # path = :abcd
    cp = try
            esplit(path)
         catch
            error("not a valid path")
         end

    if length(cp) == 1 # just the leaf name is given
      if currentChunk == currentSession.rootchunk # toplevel => create inside
        parent = currentSession.rootchunk
      else
        parent = currentChunk.parent # create sibling
      end
    else
      parent = findelem(cp[1:end-1])
    end

    name = cp[end]

    style(x) = try
                foldl(|>, x, map(eval, styling))
               catch e
                error("can't evaluate formatting functions, error $e")
               end

    newchunk(parent, name, style)
end


function newchunk(parentChunk, name, style=nothing)
  # parentChunk = currentSession.rootchunk
    global currentChunk

    nc = style==nothing ? Chunk(string(name)) : Chunk(string(name), style)
    nc.parent = parentChunk

    tc = findelem([name;], parentChunk)
    if tc == nothing # new chunk
        push!(parentChunk.children, nc)
    else # replace existing chunk
        idx = findfirst(parentChunk.children, tc)
        parentChunk[idx] = nc
    end
    currentChunk = nc

    notify(currentSession.updated)
    nothing
end

function addtochunk(t)
    # println("addtochunk $t ($(typeof(t)))")
    # Base.show_backtrace(STDOUT, backtrace())
    # println()

    currentChunk==nothing && error("No active session yet")

    push!(currentChunk.children, t)
    notify(currentSession.updated)
    nothing
end

function stationary(f::Function, signals::Signal...)
    st = lift(f, signals...)
    addtochunk(empty)
    ch   = currentChunk
    slot = length(currentChunk)
    lift(st) do nt
        ch[slot] = nt
        notify(currentSession.updated)
    end
end
