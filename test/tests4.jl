
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


############ tree chunk  ###########

module A; end

module A
reload("Paper")
using Paper

@session tree2 vbox pad(1em)

@newchunk abcd
@newchunk abcd.efg
@newchunk xys
@newchunk xys.aaa
@newchunk aaa

@newchunk bbb

@tochunk root.abcd

plaintext("abcdefqmfdgjqfg")
container(4em, 5em)

md"ceci est du *markdown*, ddddddd"

cc = Paper.findelem(["abcd";])
Paper.currentChunk

cc = Paper.findelem(["xys";])
cc.styling

Paper.currentSession.rootchunk

end

############### module logic  #################

f() = "A"

methods(f)
f()

module B
  import Main.f
  println(f())
  f() = "B"
  println(f())
  methods(f)
end

f()  # f de Main est modifié à cause du import qui lie les fonctions

x = 1
module C
  x = 2
  macro what1(arg)
    eval(arg)
  end
  macro what2(arg)
    eval(current_module(), arg)
  end
  macro what3(arg)
    eval(Main, arg)
  end
end

C.@what(:(12))
C.@what(:(current_module()))

C.@what1 x
C.@what2 x
C.@what3 x

x
C.x
