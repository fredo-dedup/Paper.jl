using Paper

using Gadfly

@rewire Gadfly.Plot

@session interactive
@loadasset "widgets"
@loadasset "signals"

title(1, "Interactive plot") |> packacross(center)
vskip(2em)

@newchunk plot hbox

f(α,β,x) = cos(α*x) * exp(- x*x/β)

sa = Input(1.)
sb = Input(1.)

@newchunk plot.slider vbox packitems(center) pad(2em)
hbox("Set α"   , slider( 0:0.05:10)  >>> sa) |> packacross(center)
hbox("Set β"   , slider( 0:0.05:2)   >>> sb) |> packacross(center)

black = colorant"black"
@newchunk plot.plot vbox border(solid, 0.1em, Main.black) pad(2em)

stationary(sa, sb) do α, β
  plot(x -> f(α,β,x), 0., 5, Scale.y_continuous(minvalue=-1,maxvalue=1))
end
