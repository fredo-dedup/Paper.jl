#########################################################
#  Chunk defs and functions
#########################################################

######## The Chunk type #########

type Chunk
  name::Symbol
  children::Vector
  parent
  styling::Function
end
Chunk() = Chunk(gensym("chunk"))
Chunk(style::Function) = Chunk(gensym("chunk"), style)
Chunk(name::Symbol) = Chunk(name, vbox) # vertical layout default
Chunk(n::Symbol, st::Function) =
  Chunk(n, Any[], nothing, st)

const δindent = 2

function show(io::IO, c::Chunk; indent=0)
  if c.name== :root
      println("show chunk :")
      Base.show_backtrace(STDOUT, backtrace())
      println()
  end
   spad = " " ^ indent
   println(io, spad, "'$(c.name)' ($(length(c.children)) elements) : ")
   for e in c.children
       if isa(e, Chunk)
           show(io, e, indent = indent + δindent)
       else
           println(io, spad, "  - ", typeof(e))
       end
   end
end

currentChunk   = nothing      # no active chunk at startup

######### Chunk find / create functions #####

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

macro newchunk(path, styling...) # path = :(xys.aaa)
    cp = try
            esplit(path)
         catch
            error("not a valid path")
         end

    if length(cp) == 1 # just the leaf name is given
      if currentChunk == currentSession.rootchunk # toplevel => create inside
        parent = currentChunk
      else
        parent = currentChunk.parent # create sibling
      end
    else
      parent = findelem(cp[1:end-1])
      parent==nothing && error("position not found")
    end

    name = cp[end]

    if length(styling)==0
        newchunk(parent, name)
    else
        sf = try
                #  map(current_module().eval, styling)
                 map(x -> eval(current_module(),x), styling)
             catch e
                 error("can't evaluate formatting functions, error $e")
             end
        style(x) = foldl(|>, x, sf)
        newchunk(parent, name, style)
    end
end


function newchunk(parentChunk, name, style=nothing)
  # parentChunk = currentChunk
    global currentChunk

    nc = style==nothing ? Chunk(name) : Chunk(name, style)
    nc.parent = parentChunk

    tc = findelem([name;], parentChunk)
    if tc == nothing # new chunk
        push!(parentChunk.children, nc)
    else # replace existing chunk
        info("resetting existing chunk $name")
        idx = findfirst(parentChunk.children, tc)
        parentChunk.children[idx] = nc
    end
    currentChunk = nc

    notify(currentSession.updated)
    nothing
end

function addtochunk(t)
    # println("addtochunk ($(typeof(t)))")
    # Base.show_backtrace(STDOUT, backtrace())
    # println()

    currentChunk==nothing && error("No active chunk yet")

    # push!(currentChunk.children, deepcopy(t))
    push!(currentChunk.children, t)
    notify(currentSession.updated)
    nothing
end

# function stationary(f::Function, signals::Signal...)
#     st = lift(f, signals...)
#     addtochunk(empty)
#     cc = currentChunk
#     slot = length(currentChunk.children)
#     lift(st) do nt
#         cc.children[slot] = nt
#         notify(currentSession.updated)
#     end
# end

function stationary(f::Function, signals::Signal...)
    local cc = currentChunk
    cc==nothing && error("No active chunk yet")

    local cs = currentSession

    println("stat 1 $(typeof(signals))  qsddqs")
    local st = Reactive.foreach(f, merge(signals...))

    push!(cc.children, empty)
    # addtochunk(empty)
    local slot = length(cc.children)
    Reactive.foreach(st) do nt
        println("stat 2 ")
        cc.children[slot] = nt
        notify(cs.updated)
    end
end
