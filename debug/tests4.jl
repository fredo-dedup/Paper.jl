################### Paper  #################

module A
  reload("Paper")
  using Paper
end

module A
# reload("Paper")
# using Paper
current_module()

# Paper.currentChunk
@session ttitle
@newchunk test
# @rewire Tile
plaintext("arg!!!")

container(2em, 4em) |> fillcolor("lightyellow")

@newchunk flox flow(horizontal) wrap maxwidth(10em)

container(2em, 4em) |> fillcolor("lightyellow")
container(2em, 4em) |> fillcolor("lightblue")
container(3em, 2em) |> fillcolor("tomato")
container(5em, 6em) |> fillcolor("magenta")

@newchunk flox
@loadasset "widgets"
@loadasset "signals"

s = Signal(10.)
typeof(s)

stationary(s) do sᵥ
  plaintext(sᵥ)
end

push!(s, 45)
push!(s, time())

@newchunk bottom2

@tochunk test
@tochunk flox
title(1, "Hello, Bottom!")

x = Signal(1.)
slid = slider(0:0.1:10)
typeof(slid)
isa(slid, Behavior)
subscribe(x, slid, absorb=false)
value(x)

stationary(x) do xᵥ
  plaintext(xᵥ)
end
push!(x,10.)

isa(slid,Tile)
isa(slid,Paper.Escher.Behavior)

x = Signal(1.)
subs = slider(0:0.1:10, value=3.) >>> x
typeof(subs)
fieldnames(subs)

subs.receiver == x
subs.intent
isa(subs, Tile)

Paper.currentChunk.children[end] == subs
Paper.Escher.object_to_id[(subs.receiver, subs.intent)]

### ça marche !!!!
Paper.compile(Pkg.dir("Paper", "debug", "compil_slider.jl"))
### mais en interactif ça marche pas

hbox( slider(0:0.1:10) >>> x )

Paper.Redisplay.render(emod.Paper.Redisplay.md, ret)

@newchunk bottom2
x = Signal(1.)
slider(0:0.1:10) >>> x

Paper.Redisplay.render(Paper.Redisplay.md, slider(0:0.1:10) >>> x)

stationary(x) do val
    vbox(
        slider(0:0.1:10) >>> x,
        plaintext("x = $val")
        )
end

Paper.Redisplay.render(Paper.Redisplay.md,
 vbox( slider(0:0.1:10) >>> x,
       map(val -> plaintext("x = $val"), x; init=3.)
      )
 )



value(x)

y = Signal(1.)

hbox(
    slider(0:0.1:10) >>> y,
    plaintext("x = $(value(y))")
)
value(y)



subscribe(slider(0:10), x)

push!(x,3)
push!(x,4)

lift(x->println("lifted $x"), x)

slider(0:10)

typeof(ws)
isa(ws, Tile)

vbox(ws)


@newchunk flux

αᵗ = Signal(1.0)
βᵗ = Signal(1.0)

vbox(md"## Dynamic plot",
    hbox("Alpha: " |>
        width(4em), slider(1:100) >>> αᵗ) |>
        packacross(center),
    hbox("Beta: "  |>
        width(4em), slider(1:100) >>> βᵗ) |>
        packacross(center),
    lift(αᵗ, βᵗ) do α, β
        plaintext("α = $α, β = $β")
    end
    ) |> pad(2em)

hbox("Alpha: " |>
    width(4em), slider(1:100) >>> αᵗ) |>
    packacross(center)
hbox("Beta: "  |>
    width(4em), slider(1:100) >>> βᵗ) |>
    packacross(center)

stationary(αᵗ, βᵗ) do α, β
    plaintext("α = $α, β = $β")
end

#####################################################


@session slidertest3
@loadasset "widgets"
# @loadasset "signals"

@newchunk test
title(1,"slider-test")

s = Signal(10.)

slider(0:0.1:30, value=20) >>> s

Paper.Redisplay.render(Paper.Redisplay.md, slider(0:0.1:10) >>> x)

stationary(s) do sᵥ
  plaintext(sᵥ)
end

456 + 456
234+234
567+567
