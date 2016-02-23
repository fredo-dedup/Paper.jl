module A ; end

α  ✪  β


######################################################################

reload("Media")
reload("Paper")
import Paper

PREFIX = Pkg.dir("Paper")

Paper.@rewire PyPlot.Figure  # direct PyPlot figures to browser


Paper.compile(joinpath(PREFIX, "examples", "gaussian-process.jl"))
Paper.notify(Paper.real_update)


module A
using Paper
@session gp2 vbox pad(3em)
@loadasset "tex"

@newchunk header vbox packacross(center) fillcolor("#ddd")
  title(2, "Gaussian Process") |> fontcolor("#000")
  title(1, "for testing purposes") |> fontstyle(italic)

Paper.notify(Paper.real_update)

@newchunk center2 columns(2, 10px) vbox

end


#########################################################################



using Paper

@session abcd
@session abcd2
@loadasset "tex"  # TeΧ equations will be needed

@newchunk header
title(3,"Titre")


@newchunk header2
Paper.title(1,"sous-titre")

z = Paper.plaintext(4+5)

typeof(z)
z

Paper.currentChunk


type AB; x; end
Paper.@rewire AB
AB(4)
AB(3)


type AB2; x; end

AB2(4)

Paper.@rewire AB2

Paper.@newchunk
@newchunk header2.text vbox packacross(center) shrink  # maxwidth(50cent)

title(1, "Definition")

@rewire Base.Markdown.MD

md"*From Wikipedia, the free encyclopedia*"

md"""
In mathematical optimization, Himmelblau's function is a multi-modal function,
used to test the performance of optimization algorithms. The function is defined by:
"""

tex("f(x,y)=(x^2+y-11)^2+(x+y^2-7)^2")

md"""
It has one local maximum at x = -0.270845 and y = -0.923039,
where f(x,y) = 181.617, and four identical local minima:

- f(3.0, 2.0) = 0.0,
- f(-2.805118, 3.131312) = 0.0,
- f(-3.779310, -3.283186) = 0.0,
- f(3.584428, -1.848126) = 0.0.

The locations of all the minima can be found analytically.
However, because they are roots of cubic polynomials, when
written in terms of radicals, the expressions are somewhat complicated.

The function is named after **David Mautner Himmelblau** (1924–2011), who introduced it.
"""


plotstyle(x) = x |> minwidth(32em) |> border(solid, 0.1em, "black")

@newchunk desc.plot vbox packacross(center)

title(1, "Contour Plot")

vskip(1em)


@session sigs
@loadasset "widgets"

@newchunk titre

αᵗ = Signal(1.0)
βᵗ = Signal(1.0)

@newchunk action hbox
@newchunk action.left vbox fillcolor("#ccf") pad(1em)

hbox("Alpha: " |>
    width(4em), slider(1:100) >>> αᵗ) |>
    packacross(center)
hbox("Beta: "  |>
    width(4em), slider(1:100) >>> βᵗ) |>
    packacross(center)

@newchunk action.right vbox fillcolor("#fcc")

stationary(αᵗ, βᵗ) do α, β
    plaintext("α = $α, β = $β")
end

@tochunk action


@newchunk footer vbox fillcolor("#cfc")
title(4, "footer")
