
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
