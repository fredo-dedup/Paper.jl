
function launch_server(updt)
    @async begin
        println("coucou")
        server = listen(2020)
        while true
            sock = accept(server)
            println("connection !")
            @async while isopen(sock)
                ns = readline(sock)
                println("received : $ns")
                @async push!(updt, ns)
            end
        end
    end
end

updt = Input{Any}("")

function main(window)
    lines = AbstractString["starting..."]

    launch_server(updt)

    lift(updt) do ns
        push!(lines, ns)
        vbox(lines...) |> pad(2em)
    end
end
