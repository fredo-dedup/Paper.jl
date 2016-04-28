module A ; end
reload("Vega")
reload("Paper")


module A
using GaussianProcesses
using Paper
using Vega

@session GP vbox pad(2em)

@rewire Vega.VegaVisualization

sleep(3.0)
vv = Paper.currentSession.window
push!(vv.assets, ("Vega", "vega-plot"))

#-------- draw the header ----------------------------------
@newchunk header vbox packacross(center) fillcolor("#ddd") pad(1em)

title(2, "Gaussian Processes")
title(1, "with plots using Vega.jl") |> fontstyle(italic)

#-------- fit the GP ----------------------------------
ts = rand(10)
ys = Float64[ rand()*0.1 + cos(x) for x in ts]

kern = Mat(1/2, -1., -2.)
  logObsNoise = -5.0               # log standard deviation of observation noise (this is optional)
  gp  = GP(ts, ys, MeanConst(mean(ys)), kern, logObsNoise)
  gp2 = GP(ts, ys, MeanConst(mean(ys)), kern)
  # optimize!(gp)

#------- plot ------------------------------------
@newchunk center columns(2, 10px) vbox

  xs = collect(linspace(0., 1., 200))
  μ, σ = predict(gp, xs)
  ci = 1.96 * sqrt(σ)

  # v  = ribbonplot(x=xs, ylow=μ-ci, yhigh=μ+ci)
  # v2 = lineplot(x = xs, y = μ)
  # nothing

big = VegaVisualization(name = "lineplot");nothing
  add_data!(big, x = xs, y = μ, name="line");nothing
  add_data!(big, x = xs, y2=μ-ci, y=μ+ci, name="zone");nothing
  add_data!(big, x = ts, y=ys, name="points");nothing
  default_scales!(big); nothing
  default_axes!(big); nothing

  big.marks =  VegaMark[]
  push!(big.marks, VegaMark())
  big.marks[1]._type = "area"
  big.marks[1].from  = VegaMarkFrom(data = "zone")
  big.marks[1].properties = VegaMarkProperties()
  big.marks[1].properties.enter = VegaMarkPropertySet()
  big.marks[1].properties.enter.x           = VegaValueRef(scale = "x", field = "x")
  big.marks[1].properties.enter.y           = VegaValueRef(scale = "y", field = "y")
  big.marks[1].properties.enter.y2          = VegaValueRef(scale = "y", field = "y2")
  big.marks[1].properties.enter.interpolate = VegaValueRef(value="monotone")
  big.marks[1].properties.enter.fill        = VegaValueRef(value= "#555")
  big.marks[1].properties.enter.fillOpacity = VegaValueRef(value= 0.3)
  big.marks[1].properties.enter.stroke        = VegaValueRef(value= "#555")
  big.marks[1].properties.enter.strokeOpacity = VegaValueRef(value= 0.6)
  # big.marks[1].properties.enter.strokeDash    = VegaValueRef(value= [10.,10.])

  # big
  # import JSON
  # show(JSON.json(tojs(big)))

  big.scales[1]._type = "linear"
  big.scales[1].zero = false
  big.scales[2].domain = VegaDataRef(data = "zone", field = ["y", "y2"])

  # big

  push!(big.marks, VegaMark())
  # big.marks[2] = VegaMark()
  big.marks[2]._type = "line"
  big.marks[2].from  = VegaMarkFrom(data = "line")
  big.marks[2].properties = VegaMarkProperties()
  big.marks[2].properties.enter = VegaMarkPropertySet()
  big.marks[2].properties.enter.x           = VegaValueRef(scale = "x", field = "x")
  big.marks[2].properties.enter.y           = VegaValueRef(scale = "y", field = "y")
  big.marks[2].properties.enter.interpolate = VegaValueRef(value="monotone")
  big.marks[2].properties.enter.stroke      = VegaValueRef(value= "#f55")

  push!(big.marks, VegaMark())
  # big.marks[3] = VegaMark()
  big.marks[3]._type = "symbol"
  big.marks[3].from  = VegaMarkFrom(data = "points")
  big.marks[3].properties = VegaMarkProperties()
  big.marks[3].properties.enter = VegaMarkPropertySet()
  big.marks[3].properties.enter.x           = VegaValueRef(scale = "x", field = "x")
  big.marks[3].properties.enter.y           = VegaValueRef(scale = "y", field = "y")
  big.marks[3].properties.enter.size        = VegaValueRef(value = 20.)
  big.marks[3].properties.enter.shape       = VegaValueRef(value = "circle")
  big.marks[3].properties.enter.stroke      = VegaValueRef(value= "#000")

  big.width, big.height = 250, 200
  big

big

fieldnames(big)
@newchunk bottom

mod = Paper.Redisplay
mod.Media.input
mod.Media.getdisplay(typeof(big))
mod.getdisplay(typeof(big))
mod.Atom.Editor()
mod.Media.input == mod.Atom.Editor()


mod.getdisplay(Vega.VegaVisualization,
  mod.Media._pool) == mod.md
  mod.getdisplay(Vega.VegaVisualization, mod.Media._pool)

mod.getdisplay(Vega.VegaVisualization, mod.Media._pool)
mod.getdisplay(Vega.VegaVisualization)
mod.getdisplay(Vega.VegaVisualization, default=mod.Atom.Editor())
mod.render(mod.Atom.Editor(), big)

mod.Media._pool
mod.Media.input
mod.Media.pool()
methods(mod.Media.pool)

##############################

layer(lineplot(x = xs, y = μ-ci), lineplot(x = xs, y = μ))

layer(scatterplot(x = ts, y = ys), lineplot(x = xs, y = μ+ci))

################  |> tests  ##########################

type B ; end

f1(x) = 2x
f2(x; var="none") = x+6

12 |> f1

+(a::B, b::B)
methods(|>)

f3(addon=4) = x -> x+addon

12 |> f3(9)

end #module
