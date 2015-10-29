
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

@session archi4
plaintext("bare session")

@chunk header
container(3em, 2em) |> fillcolor("tomato")

plaintext("ceci n'est pas une pipe")

@chunk hoohoo hbox
container(3em, 2em) |> fillcolor("yellow")

plaintext("abcd")

@chunk hoohoo2 hbox fillcolor("brown")
container(3em, 2em) |> fillcolor("lightblue")
container(3em, 5em) |> fillcolor("red")

plaintext("abcd")

@chunk hoohoo2 vbox wrap maxheight(6em)
container(3em, 2em) |> fillcolor("lightblue")
container(3em, 5em) |> fillcolor("red")

plaintext("abcd")

@session
@chunk abst

@chunk abst2 fillcolor("tomato")
plaintext("abcd")


@chunk xyz
@chunk xyz
plaintext("xyz")

@chunk www width(4em) hbox fillcolor("yellow")
plaintext("xyz")

@chunk abcd fillcolor("yellow")


title(1, "abcd") |> vbox |> fillcolor("lightblue")

@chunk xyz fillcolor("lightyellow")
@chunk abcd


end


g = x -> x |> sin |> cos
typeof(g)
g(0)
g = x -> g(x) |> cos
g(0)

h(x) = foldl(|>, x, [sin, cos])
h(0)
h(x) = foldl(|>, x, [sin, cos, cos])
h(0)

z = Sandbox.fillcolor("yellow")
typeof(z)
methods(z)
which(z, (Sandbox.Tile,))

macro dt(arg)
  dump(arg)
end

@dt ..
@dt (abcd, qsd)
@dt (~, xyz)
