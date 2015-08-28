texᵗ = Input("f(x) = \\int_{-\\infty}^\\infty
           \\hat f(\\xi)\\,e^{3 \\pi i \\xi x}
           \\,d\\xi")
using Gadfly

tock = every(5.)

function main(window)
    ys2 = Float64[0.5]
    push!(window.assets, "tex")
    push!(window.assets, "widgets")
 
    lift(tock) do t
        append!(ys2, rand(100))

        # vbox(h1("Header3"),
        #      h3("$(length(ys2))"),
        #      plot(x=Float64[1:length(ys2)], y=ys2, 
        #           Geom.point, Geom.line,
        #           Scale.x_continuous(minvalue=0, maxvalue=100),
        #           Scale.y_continuous(minvalue=0, maxvalue=1)) ) |> pad(2em) 
        vbox(h1("Header3"),
             h3("$(length(ys2))"),
             plot(x=ys2 .^ 2, 
                  Geom.histogram(bincount=20)) ) |> pad(2em) 
    end

end



# ϕᵗ = Input(0.0)

# function main(window)
#     push!(window.assets, "widgets")

#     lift(ϕᵗ) do ϕ
#         vbox(h1("Interactive plotting"),
#              hbox("Set the phase", slider(0:.01:2π) >>> ϕᵗ) |> packacross(center),
#              plot([x -> sin(x + ϕ), x -> cos(x + ϕ)], 0, 6)) |> pad(2em)
#     end
# end
