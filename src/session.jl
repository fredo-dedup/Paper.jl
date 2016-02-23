#########################################################
#  Session defs and functions
#########################################################

######## The Session type #########

type Session
  rootchunk::Chunk
  window::Window
  updated::Condition

  function Session(st::Function=vbox) # vertical layout default
    s = new()
    s.rootchunk = Chunk(:root, st)
    s.updated = Condition()
    s
  end
end

sessions = Dict{AbstractString, Session}()
currentSession = nothing      # no active active session at startup

function show(io::IO, s::Session)
   show(s.rootchunk)
end

############ user commands ##################

macro session(args...)
    sn = gensym("session") # default session name
    length(args) == 0 && return session(sn)

    i0 = 1
    if isa(args[1], Symbol)  # we will presume it is the session name
        sn = string(args[1])
        i0 += 1
    end

    i0 > length(args) && return session(sn)

    sf = try
             map(x -> eval(current_module(),x), args[i0:end])
         catch e
             error("can't evaluate formatting functions, error $e")
         end
    style(x) = foldl(|>, x, sf)
    session(sn, style)
end

function session(name::AbstractString, style=nothing)
    global currentSession, currentChunk

    if haskey(sessions, name)
        info("resetting existing session $name")
    end

    newsession     = style==nothing ? Session() : Session(style)
    sessions[name] = newsession
    currentSession = newsession
    currentChunk   = newsession.rootchunk

    serverid == nothing && init() # launch server if needed

    fulladdr = "http://127.0.0.1:$port/$name"
    @linux_only   run(`xdg-open $fulladdr`)
    @osx_only     run(`open $fulladdr`)
    @windows_only run(`cmd /c start $fulladdr`)
end


# TODO : close_session, switch session


##### builds the Escher page structure  ######

dashedborder(t)  = t |> borderwidth(1px) |> bordercolor("#aaa") |>
                    borderstyle(dashed)
italicmessage(t) = t |> fontcolor("#aaa") |> fontstyle(italic)

function build(chunk::Chunk, parentname::AbstractString)
    # session = p.sessions[:abcd]
    # if parentname==""
    #     println("build :")
    #     Base.show_backtrace(STDOUT, backtrace())
    #     println()
    # end
    parentname=="" && println("build")

    currentname = parentname=="" ?  string(chunk.name) :
                    parentname * "." * string(chunk.name)
    try
        nbel = length(chunk.children)
        println("build, nbel = $nbel, current $(chunk==currentChunk)")
        if nbel==0
          ret = title(1, currentname) |> italicmessage
        else
          ret = map(c -> build(c, currentname), chunk.children)
        end

        ret = ret |> chunk.styling
        if chunk==currentChunk
           ret = ret |> dashedborder
        end

        return ret
    catch err
        bt = catch_backtrace()
        str = sprint() do io
            showerror(io, err)
            Base.show_backtrace(io, bt)
        end
        return Elem(:pre, str)
    end
end

build(session::Session)    = build(session.rootchunk, "")
build(t, ::AbstractString) = t
