using GaussianProcesses
using Paper

import PyPlot
PyPlot.pygui(false)  # do not use Python window, display in browser instead
PyPlot.plt[:ioff]()  # to avoid bug appearing when is-interactive = true
# PyPlot.plt[:ion]()  # to avoid bug appearing when is-interactive = true
PyPlot.svg(true)     # SVG graphs are cleaner

@rewire PyPlot.Figure  # direct PyPlot figures to browser

ts = rand(10)
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

kern = Mat(1/2, -1., -2.)
  logObsNoise = -5.0               # log standard deviation of observation noise (this is optional)
  gp  = GP(ts, ys, MeanConst(mean(ys)), kern, logObsNoise)
  gp2 = GP(ts, ys, MeanConst(mean(ys)), kern)
  # optimize!(gp)

#------- affichage ------------------------------------

@session GP2 vbox pad(2em)
@loadasset "tex"

@newchunk header vbox packacross(center) fillcolor("#ddd")
  title(2, "Gaussian Process") |> fontcolor("#000")
  title(1, "for testing purposes") |> fontstyle(italic)

Paper.notify(Paper.real_update)

@newchunk center columns(2, 10px) vbox

plaintext("points et modèle:")
xs = collect(linspace(0., 1., 300))
μ, σ = predict(gp, xs)
ci = 1.96 * sqrt(σ)

PyPlot.figure()  # reset plotting area
PyPlot.fill_between(xs, μ-ci, μ+ci, facecolor="gray", alpha=0.3)
PyPlot.plot(xs, μ, "k-")
PyPlot.plot(ts, ys, "*")
PyPlot.gcf()

μ2, σ2 = predict(gp2, xs)
ci2 = 1.96 * sqrt(σ2)
PyPlot.figure()  # reset plotting area
PyPlot.fill_between(xs, μ2-ci2, μ2+ci2, facecolor="lightblue", alpha=0.3)
PyPlot.plot(xs, μ2, "b-")
PyPlot.plot(ts, ys, "*")
PyPlot.gcf()



@newchunk center2 vbox
plaintext("jqsdvm")
tex("\\Sigma^{N}_{i=1}")
tex("T = 2\\pi\\sqrt{L\\over g}")

Paper.notify(Paper.real_update)

@newchunk after
tex("f(x,y)=(x^2+y-11)^2+(x+y^2-7)^2")



######################
#
# module Escher
#
# @api columns => (Columns <: Tile) begin
#     doc("Set the number of columns.")
#     arg(ncol::Int, doc="The number.")
#     arg(gap::Length=1px, doc="The gap size between columns.")
#     curry(tiles::TileList, doc="A tile or a vector of tiles.")
# end
#
#
# @api columns2 => (Columns2 <: Tile) begin
#     doc("Set the number of columns.")
#     arg(ncol::Int, doc="The number.")
#     # kwarg(gap::Length=1px, doc="The gap size between columns.")
#     curry(tiles::TileList, doc="A tile or a vector of tiles.")
# end
#
#
#
# #  0px
# z = 1px
#
# render(t::Columns, state) =
#     wrapmany(t.tiles, :span, state) &
#         style(@d(symbol("column-count")         => t.ncol,
#                  symbol("-webkit-column-count") => t.ncol,
#                  symbol("-moz-column-count")    => t.ncol,
#                  symbol("column-gap")           => t.gap,
#                  symbol("-webkit-column-gap")   => t.gap,
#                  symbol("-moz-column-gap")      => t.gap))
#
# render(t::Columns2, state) =
#    wrapmany(t.tiles, :span, state) &
#        style(@d(symbol("column-count")         => t.ncol,
#                 symbol("-webkit-column-count") => t.ncol,
#                 symbol("-moz-column-count")    => t.ncol))
#
#
#
# @api columns2 => (Columns2 <: Tile) begin
#     doc("Set the number of columns.")
#     curry(tile::Tile, doc="A tile.")
#     arg(ncol::Int, doc="The number of columns.")
#     kwarg(gap::Length=1px, doc="The gap size between columns.")
# end
#
# render(t::Columns2, state) =
#     render(t.tile, state) &
#         style(@d(symbol("column-count") => t.ncol,
#                  symbol("-webkit-column-count") => t.ncol,
#                  symbol("-moz-column-count") => t.ncol,
#                  symbol("column-gap") => t.gap,
#                  symbol("-webkit-column-gap") => t.gap,
#                  symbol("-moz-column-gap") => t.gap))
#
# end
