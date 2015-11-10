
Media.input
Media.input[]

################### Paper  #################

module A
  reload("Paper")
  using Paper
end

module A
reload("Paper")
using Paper
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

slider(0:0.1:20)
error("oqisd")
s = Input(10.)
plaintext("abcd")

stationary(s) do sᵥ
  plaintext(sᵥ)
end
push!(s, 45)
push!(s, 30)

Paper.Elem(:h1, "Hello, World!")



x = Input(1.)
slider(0:0.1:10) >>> x
subscribe(slider(0:10), x)

push!(x,3)
push!(x,4)

lift(x->println("lifted $x"), x)

slider(0:10)

typeof(ws)
isa(ws, Tile)

vbox(ws)


@newchunk flux

αᵗ = Input(1.0)
βᵗ = Input(1.0)

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

@loadasset "widgets"

container(4em, 4em) |> fillcolor("blue")
end

############### module logic  #################

f() = "A"

methods(f)
f()

module B
  import Main.f
  println(f())
  f() = "B"
  println(f())
  methods(f)
end

f()  # f de Main est modifié à cause du import qui lie les fonctions

x = 1
module C
  x = 2
  macro what1(arg)
    eval(arg)
  end
  macro what2(arg)
    eval(current_module(), arg)
  end
  macro what3(arg)
    eval(Main, arg)
  end
end

C.@what(:(12))
C.@what(:(current_module()))

C.@what1 x
C.@what2 x
C.@what3 x

x
C.x

#####   Compilation function : compile()

script = IOBuffer("""
 using Paper
 a + 3
 @session compilation
  @newchunk test
 container(3em, 3em) |> fillcolor("tomato")
 4+5
  """)

module A;end
module A
reload("Paper")
using Paper
isrewired(Tile)

@session A
@newchunk ab vbox pad(1em)
title(2, "test test")

@newchunk cd x -> map(pad(1em),x) vbox
title(2, "test test")

pwd()
compile(joinpath(Pkg.dir("Paper"), "examples/Himmelblau.jl"))

whos()

@loadasset "tex"

script = IOBuffer("""
 using Paper
 @session compilation
 @newchunk test
 plaintext("current_module() : $(current_module())")
 @newchunk abcd vbox fillcolor("lightgray")
 t = container(100cent, 10px) |> fillcolor("tomato");
 plaintext(4+5)
 """)

compile(script)

compile(joinpath(Pkg.dir("Paper"), "test/compil_ex.jl"))

Paper.sessions


Base.binding_module(:(@newchunk))
end
