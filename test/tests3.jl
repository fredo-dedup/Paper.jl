###########   display ???  ###########################
display(12)
methods(display)
methods(display, (Any, MIME{symbol("text/plain")}, Any))
methods(redisplay)

meths = methods(display, (Any, MIME{symbol("text/plain")}, Number))
Base.Multimedia.displays

p.title(2,"Header")

p.title(2,md"Hea**de**r")

p.addtochunk(5+6)
p.addtochunk(md" aaaa *bb* ccc")


p.@chunk test bordercolor("#d4c")
p.@chunk test2
p.@chunk test

p.addtochunk(4456)

methods(Media.setdisplay)

4456
5+6
writemime(STDOUT, MIME"text/plain"(), 12)
p.currentChunk
3
12
1

#####################################################################
using Paper
import Media

@session display
@chunk block

plaintext("lfqslkdfhlqskdfh")

methods(show, (Tile,))

immutable PaperDisplay <: Display ; end
immutable MauritsDisplay <: Display ; end

Media.setdisplay(Tile, PaperDisplay)
Media.setdisplay(Tile, momo)

momo = MauritsDisplay()

methods(render)
import Media.render
import Escher.render
function Media.render(::MauritsDisplay, t::Tile)
  println("was here 2 !!")
	Paper.addtochunk(t)
end

pt = plaintext("lfqslkdfhlqskdfh")
Media.pool(Media.current_input())
Media.getdisplay(typeof(pt), Media.pool(Media.current_input()))

methods(render, (PaperDisplay, Tile))

import Base.Multimedia.display
function display(::PaperDisplay, "text/plain", t::Tile)
  println("was here !!")
	Paper.addtochunk(t)
end
display(d::PaperDisplay, t::Tile) = display(d, "text/plain", t)

methods(display)

t = plaintext("akjhaz")
typeof(t)
Paper.addtochunk(t)
display(t)
methods(display, (Tile,))

############################################################
5+6
module Sandbox2; end
module Sandbox2

reload("Paper")
using Paper

Paper.sessions

a = 20
current_module()

@session show6 pad(1em)
@chunk TT2
Paper.addtochunk("abcd")
Paper.addtochunk(title(3, "Titre"))
tv = title(3, "nouveau Titre")
typeof(tv)
isa(tv, Tile)

t = tex("\\sum")
Paper.currentChunk

m1 = methods(writemime, (IO, MIME"text/plain", Any))

import Base.Multimedia.writemime
# marche si appelé explicitement, @rewire marche pas
writemime(io::IO, ::MIME"text/plain", t::Tile) = Paper.addtochunk( t )

m2 = methods(writemime, (IO, MIME"text/plain", Any))

println(m1[1], " /// ", m2[1])
for i in 1:length(m1)
  println(m1[i]==m2[i])
end

type Foo ; end
Foo() # pas d'affichage
writemime(io::IO, ::MIME"text/plain", t::Foo) = Paper.addtochunk( "foo !" )
Foo() # affichage

type Foo2 ; end
Foo2() # pas d'affichage
Paper.rewire(Foo2) do x
    Paper.addtochunk("foo 2 !")
end
export writemime # change rien
Foo2() # marche pas

writemime(io::IO, ::MIME"text/plain", t::Foo) = Paper.addtochunk( "foo !" )
Foo() # affichage


end
############################################################

module Sandbox; end
module Sandbox
using Paper
using Media
using Graphics

type PaperDisplay ; end

pd = PaperDisplay()

type Foo; end

import Base.Multimedia.writemime
function writemime(io::IO, ::MIME"text/plain", t::Sandbox.Foo)
    println("writemime ...")
    Base.show_backtrace(STDOUT, backtrace())
end
writemime(io::IO, ::MIME"text/plain", t::Foo) = Paper.addtochunk( "foo !" )

f() = 4.
f()
rand(2,2)
Foo()
456+46
 465+3
5+6
methods(writemime, (IO, MIME"text/plain", AbstractArray))

import Base.Multimedia.writemime
function writemime(io::IO, ::MIME"text/plain", t::Sandbox.Foo)
    println("writemime ...")
    Base.show_backtrace(STDOUT, backtrace())
end
Sandbox.Foo()

type Foo2; end
Foo2()
setdisplay(Foo, pd)

import Graphics.render
function render(pd::PaperDisplay, x)
  println("yo ça marche")
end

Foo()

end

Foo()
Abcd()
whos()
using Paper
reload("Paper")

a
Sandbox2.a

methods(writemime, (IO, MIME"text/plain", Any))
type TT; x ; end
import Base.show
show(io::IO, t::TT) = (println("been here") ; Base.show_backtrace(STDOUT, backtrace()); println())

@session show
@chunk TT
Paper.addtochunk("abcd")
Paper.addtochunk(title(3, "Titre"))
title(3, "Titre")

TT(2)

import Base.Multimedia.writemime
function writemime(io::IO, ::MIME"text/plain", Any, x::TT)
  println("been here 3")
  Paper.addtochunk( string(x.x) )
end

macro test(outer,inner=[])
end


# marche si appelé explicitement, @rewire marche pas
writemime(io::IO, ::MIME"text/plain", t::Tile) = Paper.addtochunk( t )

@rewire Tile

TT(2)
TT(5)

plaintext("yoooooooooooo")
title(1, "this a test")

Paper.rewire(x -> Paper.addtochunk("ha ha"), Main.TT)

VERSION
Paper.currentChunk

############################################################

using Blink, Gadfly
BlinkDisplay.init()
Gadfly.plot(x = 1:100, y = cumsum(rand(100)-0.5), Geom.line)


function tf(x)
  abcd() = x
end

a = tf(4)
a
a()

b = tf(5)
b()

c = tf(125)
c()

a == c
a == b
methods(a)
