using Paper
using Colors

# import Gadfly to show plots
using Gadfly

# indicate that Gadfly plots should be sent to the browser
@rewire Gadfly.Plot

@session Himmelblau vbox pad(1em)
@loadasset "tex"  # TeΧ equations will be needed

@newchunk header vbox packacross(center)
title(3, "Himmelblau's function")
vskip(2em)

# start a chunk with an horizontal flow
@newchunk desc hbox

# start an inner chunk, with a vertical flow
@newchunk desc.text vbox packacross(center) shrink  # maxwidth(50cent)

title(1, "Definition")

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

# start the second inner chunk showing the plot on the right side of Definition

# style elements can be defined as functions for multiple reuse for example
plotstyle(x) = x |> minwidth(32em) |> border(solid, 0.1em, colorant"black")

@newchunk desc.plot vbox packacross(center) Main.plotstyle

title(1, "Contour Plot")

vskip(1em)

f(x,y) = (x^2+y-11)^2+(x+y^2-7)^2

plot(z=f, x=linspace(-5,5,150), y=linspace(-5,5,150),
	 	  Geom.contour(levels=logspace(0,3,15) - 1))

caption(md"This is a Graph of *Himmelblau*'s function")

@tochunk desc
