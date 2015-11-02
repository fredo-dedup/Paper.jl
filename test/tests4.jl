
Media.input
Media.input[]

################### Paper  #################

module Sandbox
  reload("Paper")
  using Paper
end

module Sandbox
reload("Paper")
using Paper
current_module()
whos(Sandbox)
# Paper.currentChunk
@session ttitle
@chunk testtffest
# @rewire Tile
plaintext("arg!!!")

container(2em, 4em) |> fillcolor("lightyellow")

ab = [container(2em, 4em) |> fillcolor("lightyellow"),
      container(2em, 4em) |> fillcolor("lightblue"),
      container(3em, 2em) |> fillcolor("tomato"),
      container(5em, 6em) |> fillcolor("magenta")]

ab |> flow(vertical) |> wrap |> maxheight(5em)
@chunk maxwidth(10em)
ab |> flow(horizontal) |> wrap

@nchunk width(12cm) flow(horizontal) wrap
width(12cm)
flow(horizontal)
wrap(center)

@chunk maxwidth(2cm) width(12cm) flow(horizontal) wrap

container(4em, 4em) |> fillcolor("blue")
end

######### new archi ##########
reload("Paper")

a = fillcolor("tomato")
flow(horizontal) |> fillcolor("lightyellow")
fillcolor(flow(horizontal), "lightyellow")
typeof(a)
styl(x) = x |> flow(horizontal) |> fillcolor("lightyellow")

module Sandbox ; end

module Sandbox
reload("Paper")
using Paper

@session archi
plaintext("bare session")
@chunk header

container(3em, 2em) |> fillcolor("tomato")
plaintext("ceci n'est pas une pipe")
@chunk hoohoo
plaintext("abcd")
@chunk xyz vbox fillcolor("lightblue")
plaintext("xyz")

@chunk ww hbox fillcolor("lightyellow")
plaintext("xyz")
@chunk ww1 vbox wrap fillcolor("lightgreen")

plaintext("abc")




end

######### tree chunk struct ##########
ex = :( ~abcd/xyz )

macro rr(args...)
  dump(args[1])
end

@rr ~abcd/xyz
@rr ~abcd/xyz/azer
@rr "../aze"
@rr ~ / new
@rr (new,)
@rr (..,..,new)
@rr (~,new)
@rr abcd.dqsd.qsd
@rr ~~abcd.qsd

module Paper
function spat(ex) # ex = :(xyz.aa)
  # ex = ex.args[1]
  isa(ex, QuoteNode) && return ex.value
  isa(ex, Symbol)    && return ex

  isa(ex, Expr)      || error("format")

  ex.head == :. && return [spat(ex.args[1]); spat(ex.args[2])]
  ex.head == :quote && return ex.args[1]

  error("format")
end


end

spit(:(xyz.aa))
dump(:(xyz.aa))

macro rr2(path)
  spat(path)
end

@rr2 abcd.xyz.aa
dump(:(abcd.xyz.aa))
spit(:(abcd.xs))
5+6


ex = :(azer + azfer)
dump(ex)
5+66
<<<<<<< Updated upstream

end

reload("ReverseDiffSource")
using ReverseDiffSource
i = 1
ex = ReverseDiffSource.rdiff( :( exp(x)[i] ), x=[1.,2] )
@eval function mex(x)
        res = Array(Float64, length(x), length(x)) # will hold the result
        for i in 1:length(x)
          _ , res[i,:] = $ex
        end
        res
      end

mex([2.])
mex(ones(5))

ex
=======
Paper

function getW33(k::Float64)
    sqrt2l= sqrt(2.0)
    t2 = k*k
    t3 = acos(t2 - 1.0)
    t4 = 2.0 - t2
    t6 = 2*π - t3
    t5 = 1.0/t4
    (t6 * sqrt(t5) - k)*t5
end

k = 0.5
getW33(k)

dapprox(f, x, ϵ=1e-8) = (f(x+ϵ)-f(x)) / ϵ
getW33(k+1e-10)

dapprox(getW33, 0.5)

using ReverseDiffSource

@deriv_rule acos(x::Real) x -ds / sqrt(1-x*x)
dget = rdiff(getW33, (0.5,))
dget(0.5)
>>>>>>> Stashed changes
