module A ; end
reload("VegaLite")
reload("Paper")

################# testing Vega branch  #####################

module A
using VegaLite
buttons(false)
buttons(true)
using Paper

@session Vega
@rewire VegaLiteVis

@newchunk header
title(2,"Pie charts")

vv = Paper.currentSession.window
push!(vv.assets, ("VegaLite", "vega-lite"))

@newchunk center

N = 10
  props = rand(N)
  as = 2π * cumsum(props) / sum(props)
  push!(as, as[1])

N₂ = 1
  xs = Array(Float64, 4, N₂)
  ys = Array(Float64, 4, N₂)

inner, outer = 10., 20.
  ϵ = 2π * 0.02
  for i in 1:N₂
   xs[:,i] = [sin(as[i]   + ϵ)*inner, sin(as[i]   + ϵ)*outer,
              sin(as[i+1] - ϵ)*outer, sin(as[i+1] - ϵ)*inner ]
   ys[:,i] = [cos(as[i]   + ϵ)*inner, cos(as[i]   + ϵ)*outer,
              cos(as[i+1] - ϵ)*outer, cos(as[i+1] - ϵ)*inner ]
  end

vskip(1em)

v = data_values(x=vec(xs), y=vec(ys),
                group=repeat([1:N₂;],inner=[4]),
                order=[1:4N₂;] ) +
    mark_line() +
    encoding_x_quant(:x) + encoding_y_quant(:y) +
    encoding_color_ord(:group) +
    encoding_path_ord(:order) +
    encoding_detail_nominal(:group)

buttons(false)
buttons(true)
svg(false)
svg(true)

using RDatasets

mpg = dataset("ggplot2", "mpg")

@rewire DataFrame

head(mpg)



@newchunk center
@newchunk center2 hbox

  data_values(mpg) +
  mark_text() +
  encoding_column_ord(:Year) +
  encoding_row_ord(:Manufacturer) +
  encoding_color_nominal(:Manufacturer) +
  encoding_text_quant(:Displ, aggregate="mean") +
  config_mark(fontSize=12, format="3.2f", font="courier")

data_values(mpg) +
  mark_bar() +
  encoding_column_ord(:Year) +
  encoding_y_ord(:Manufacturer) +
  encoding_color_nominal(:Manufacturer) +
  encoding_x_quant(:Displ, aggregate="mean",
                   scale=scale(clamp=true, zero=false))


xs = [0:0.1:2.]
ys  = map(sin, xs)
ys2 = map(sin, xs+1.3)
δ = 0.1

lineplot(x=xs, y=ys)
v = ribbonplot(x=xs, ylow=ys-δ, yhigh=ys+δ)

v = ribbonplot(x=[xs,xs+0.2], ylow=[ys,ys2]-δ, yhigh=[ys,ys2]+δ,
           group=repeat([:A, :B],inner=[length(xs);]))

import JSON
show(JSON.json(tojs(v)))

areaplot(x=[xs,xs], y=[ys,ys2]+δ,
         group=repeat([:A, :B],inner=[length(xs);]))

lineplot(x=[xs,xs], y=[ys,ys2]+δ,
        group=repeat([:A, :B],inner=[length(xs);]))


layer(lineplot(x=xs, y=ys-2δ),
      ribbonplot(x=xs, ylow=ys-δ, yhigh=ys+δ))

end

######################################################################
module A
reload("Paper")
using Paper
reload("Media")

PREFIX = Pkg.dir("Paper")

# Paper.@rewire PyPlot.Figure  # direct PyPlot figures to browser
# isrewired(PyPlot.Figure)

Paper.compile(joinpath(PREFIX, "examples", "gaussian-process.jl"))
Paper.compile(joinpath(PREFIX, "examples", "vega.jl"))
Paper.compile(joinpath(PREFIX, "examples", "GP.jl"))

end






notify(Paper.currentSession.updated)
sess = Paper.currentSession
length(sess.rootchunk.children)
fieldnames(sess)
dump(sess.rootchunk.children[2].children[1])
sess.rootchunk.name
sess.rootchunk

Paper.compile(joinpath(PREFIX, "examples", "vega.jl"))
Paper.notify(Paper.real_update)


sess.rootchunk.children[2].children[1]


module A
using Paper
@session gp2 vbox pad(3em)
@loadasset "tex"

@newchunk header vbox packacross(center) fillcolor("#ddd")
title(2, "Gaussian Process") |> fontcolor("#000")
title(1, "for testing purposes") |> fontstyle(italic)

@newchunk center hbox wrap
container(100px,100px) |> fillcolor("#d88")

Paper.notify(Paper.real_update)

@newchunk center2 columns(2, 10px) vbox

end


#########################################################################
module A; end

module A
using Paper
using Vega

x = [95, 86.5, 80.8, 80.4, 80.3, 78.4, 74.2, 73.5, 71, 69.2, 68.6, 65.5, 65.4, 63.4, 64]
y = [95, 102.9, 91.5, 102.5, 86.1, 70.1, 68.5, 83.1, 93.2, 57.6, 20, 126.4, 50.8, 51.8, 82.9]
cont = ["EU", "EU", "EU", "EU", "EU", "EU", "EU", "NO", "EU", "EU", "RU", "US", "EU", "EU", "NZ"]
z = [13.8, 14.7, 15.8, 12, 11.8, 16.6, 14.5, 10, 24.7, 10.4, 16, 35.3, 28.5, 15.4, 31.3]

@session Vega
@loadasset "tex"
@loadasset "texttqsd"
@loadasset "widgets"

push!(Paper.currentSession.window.assets, "tex")

@newchunk textex
tex("\\Sigma^{N}_{i=1}")
plaintext("active ?")

@loadasset(("Vega", "vega-plot"))

vv = Paper.currentSession.window
push!(vv.assets, ("Vega", "vega-plot"))

methods(Paper.render, (Vega.VegaVisualization, Any))
@newchunk vvv
Paper.notify(Paper.real_update)

@rewire Vega.VegaVisualization
isrewired(VegaVisualization)

v = bubblechart(x = x, y = y, group = cont, pointSize = z)
typeof(v)
Vega.tojson(v)
v

bubblechart(x = x, y = y, group = cont, pointSize = z) |>
  xlim!(min = 60, max = 100) |>
  ylim!(min = 10, max = 160)

methods(xlim!)
plaintext("abcd")

#Chart mods
v.width = 600
v.height = 300
Vega.xlim!(v, min = 60, max = 100)
Vega.ylim!(v, min = 10, max = 160)
Vega.title!(v, title = "Sugar and Fat Intake Per Country")
Vega.ylab!(v, title = "Daily Sugar Intake", grid = true)
Vega.xlab!(v, title = "Daily Fat Intake", grid = true)
Vega.hline!(v, value = 50, strokeDash = 5, stroke = "gray")
Vega.vline!(v, value = 65, strokeDash = 5, stroke = "gray")
Vega.hover!(v, opacity = 0.5)

v |> v->hover!(v,opacity=0.2)


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
