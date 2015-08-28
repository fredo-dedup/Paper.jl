


news = Input("")
lines = AbstractString[]

    @async begin
        server = listen(2014)
        while true
            sock = accept(server)
            println("accepted !")
            @async while isopen(sock)
                println("waiting for line")
                ns = readline(sock)
                println("line found! : $ns")
                push!(news, ns)
                push!(lines, ns)
                println(lines)
            end
        end
    end

function main(window)

    lift(news) do ns
        vbox(lines...) |> pad(2em)
    end
end
