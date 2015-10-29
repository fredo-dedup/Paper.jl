
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
Paper
