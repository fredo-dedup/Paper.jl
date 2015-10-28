
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

container(3em, 2em) |>fillcolor("tomato")
plaintext("ceci n'est pas une pipe")
@chunk hoohoo
plaintext("abcd")
@chunk xyz fillcolor("lightblue")
plaintext("xyz")

end
