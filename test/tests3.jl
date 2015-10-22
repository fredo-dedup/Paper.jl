###########   display ???  ###########################
display(12)
methods(display)
methods(display, (Any, MIME{symbol("text/plain")}, Any))
methods(redisplay)

          meths = methods(display, (Any, MIME{symbol("text/plain")}, Number))


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
using Paper

methods(writemime, (IO, MIME"text/plain", Any))
type TT; x ; end
import Base.show
show(io::IO, t::TT) = (println("been here") ; Base.show_backtrace(STDOUT, backtrace()); println())

@session show
@chunk TT
Paper.addtochunk("abcd")
TT(2)

import Base.Multimedia.writemime
function writemime(io::IO, ::MIME"text/plain", Any, x::TT)
    println("been here 3")
    Paper.addtochunk( string(x.x) )
end

function writemime(io::IO, ::MIME"text/plain", t::Tile)
    Paper.addtochunk( t )
end

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
