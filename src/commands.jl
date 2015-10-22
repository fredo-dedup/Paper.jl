############ user commands ##################

    macro chunk(args...)
        length(args) == 0 && return chunk(gensym("chunk"))

        if isa(args[1], Symbol)  # we will presume it is the chunk name
            cn = args[1]
            i0 = 2
        else
            cn = gensym("chunk")
            i0 = 1
        end

        style = []
        for a in args[i0:end]
            try
                push!(style, eval(a))
            catch e
                warn("can't evaluate $a, error $e")
            end
        end
        chunk(cn, style)
    end


    function chunk(name, style=[])
        global currentChunk

        currentSession==nothing && session(gensym("session")) # open new session

        if name in currentSession.chunknames # replace existing chunk
            index = indexin([name], currentSession.chunknames)[1]
            currentSession.chunks[index] = []
            currentSession.chunkstyles[index] = style
            currentChunk = currentSession.chunks[index]
        else
            push!(currentSession.chunknames, name)
            push!(currentSession.chunks,       [])
            push!(currentSession.chunkstyles,  style)
            currentChunk = currentSession.chunks[end]
        end

        notify(updated)
        nothing
    end


    function addtochunk(t)
        println("addtochunk $t ($(typeof(t)))")
        Base.show_backtrace(STDOUT, backtrace())
        println() ; println()

        if currentSession==nothing
            println("No active session yet")
            return
        elseif currentChunk==nothing
            println("No active chunk yet, run @chunk")
            return
        end
        push!(currentChunk, t)
        notify(updated)
        nothing
    end

    function stationary(f::Function, signals::Signal...)
        st = lift(f, signals...)
        addtochunk(empty)
        ch   = currentChunk
        slot = length(currentChunk)
        lift(st) do nt
            ch[slot] = nt
            notify(updated)
        end
    end
