using Paper

@session slidertest3
@loadasset "widgets"
# @loadasset "signals"

@newchunk test
title(1,"slider-test")

s = Signal(10.)

slider(0:0.1:30, value=20) >>> s

value(s)

stationary(s) do sᵥ
  plaintext(sᵥ)
end
