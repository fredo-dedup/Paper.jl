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
function findelem(ns::Vector, startelem::Chunk=currentSession.rootchunk)
  for e in startelem.children
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

macro newchunk(path, styling...)
    cp = try
            esplit(path)
         catch
            error("not a valid path")
         end
    parent = length(cp) == 1 ? currentChunk : # just the leaf name is given
                               findelem(cp[1:end-1])

    name = cp[end]

    style(x) = try
                foldl(|>, x, map(eval, styling))
               catch e
                error("can't evaluate formatting functions, error $e")
               end

    newchunk(parent, name, style)
end

# macro chunk(args...)
#   cn = "_chunk$(length(currentChunk.children)+1)" # default chunk name
#   length(args) == 0 && return chunk(cn)
#
#   i0 = 1
#   if isa(args[1], Symbol)  # we will presume it is the session name
#       cn = string(args[1])
#       i0 += 1
#   end
#
#   i0 > length(args) && return chunk(cn)
#
#   style(x) = try
#                foldl(|>, x, map(eval, args[i0:end]))
#              catch e
#                error("can't evaluate formatting functions, error $e")
#              end
#
#   chunk(cn, style)
# end

# function chunk(name, style=nothing)
#     global currentChunk
#
#     currentSession==nothing && session("session") # open new session
#
#     # if name in currentSession.chunknames # replace existing chunk
#     #     index = indexin([name], currentSession.chunknames)[1]
#     #     currentSession.chunks[index] = []
#     #     currentSession.chunkstyles[index] = style
#     #     currentChunk = currentSession.chunks[index]
#     # else
#         nc = style==nothing ? Chunk(name) : Chunk(name, style)
#         push!(currentChunk.children, nc)
#         nc.parent = currentChunk
#         currentChunk = nc
#     # end
#
#     notify(currentSession.updated)
#     nothing
# end

function newchunk(parentChunk, name, style=nothing)
    global currentChunk

    currentSession==nothing && session("session") # open new session

    tc = findelem([name;], parentChunk)
    nc = style==nothing ? Chunk(string(name)) : Chunk(string(name), style)
    nc.parent = parentChunk
    if tc == nothing # new chunk
        push!(parentChunk.children, nc)
    else
        idx = findfirst(parentChunk.children, tc)
        parentChunk[idx] = nc
    end
    currentChunk = parentChunk

    notify(currentSession.updated)
    nothing
end

function addtochunk(t)
    # println("addtochunk $t ($(typeof(t)))")
    # Base.show_backtrace(STDOUT, backtrace())
    # println()

    currentChunk==nothing &&
      error("No active session yet")

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
