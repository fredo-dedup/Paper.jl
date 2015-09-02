using Paper
using Markdown

using Gadfly

Paper.rewire(Gadfly.Plot) do p
	Paper.addtochunk(convert(Paper.Tile, p))
end

Paper.launch()

reload("Paper")
Paper.init()
Paper.reset()

###############################

Paper.chunk(:start)
title(3, "Himmelblau's function")

Paper.chunk(:desc)
title(1, "Definition")
tex("f(x,y)=(x^2+y-11)^2+(x+y^2-7)^2") |> pad(1em)

Paper.chunk(:plot)
title(1, "Contour Plot")

f(x,y) = (x^2+y-11)^2+(x+y^2-7)^2

vskip(1em)

bl = vbox(plot(z=f, x=linspace(-5,5,150), y=linspace(-5,5,150), 
	 			Geom.contour(levels=logspace(0,3,15) - 1)),
	 	  caption(md"This is a Graph of *Himmelblau*'s function")) |> 
		packacross(center);

Paper.chunk(:plot)


Paper.chunk(:test)
plot(z=f, x=linspace(-5,5,150), y=linspace(-5,5,150), Geom.contour) |> shrink(0.1)
drawing( 400px, 300px, plot(z=f, x=linspace(-5,5,150), y=linspace(-5,5,150), Geom.contour))

methods(drawing)

bl |> packitems(axisstart) |> width(10em)
flex(bl) |> borderstyle(solid) |> borderwidth(1Paper.px)

bl |> packacross(center) |> borderstyle(solid) |> borderwidth(1Paper.px) |> vbox()

Paper.chunk(:plot2)
plot(z=f, x=linspace(-5,5,150), y=linspace(-5,5,150), 
	 Geom.contour(levels=logspace(0,3,15) - 1))

convert(Tile,"aze") |> fontweight(900)
"xyz"

include("examples/mini.jl")
Paper.lift(x -> println(x), Paper.window.dimension)


