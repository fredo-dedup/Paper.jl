
news2 = Input("")
lines = AbstractString["starting..."]

@async begin
    server = listen(2016)
    while true
        sock = accept(server)
        println("accepted !")
        @async while isopen(sock)
            println("waiting for line")
            ns = readline(sock)
            println("line found! : $ns")
            @async push!(news2, ns)
            println(lines)
        end
    end
end

function main(window)


    lift(news2) do ns
        push!(lines, ns)
        vbox(lines...) |> pad(2em)
    end
end
