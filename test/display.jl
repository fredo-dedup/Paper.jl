######### understanding Media and display  ######
using Media

type Mydisplay; end

type Foo; x; end

setdisplay(Foo, Mydisplay())

import Media.render
function render(pd::Mydisplay, x::Foo)
  println("yo ça marche")
end

methods(render)

Foo(12)
display(Foo(2))

whos(Media)

module Media
whos()
pool
getdisplay(Foo, pool())
end

#############################################################

using Media

import Media: render


type Foo ; x ; end
Foo
typeof(Foo(12))
Foo(12)


type MyD end
methods(setdisplay)
setdisplay(Foo, MyD())

render(::MyD, x::Foo) = "abcd"
render(::Any, x::Foo, ::MyD) = "xyz"
render(::Atom.Editor, x::Foo) = "xyz" # ça marche

methods(render, (Any, Foo))

methods(render)

render(MyD(), Foo(12))

Foo(45)

      render(e::Editor, ::Void; options = @d()) =
        render(e, Text("✓"), options = options)

############################################################
using Paper


using Media

methods(render, (Any, Tile))

getdisplay(Foo, Media.pool())



methods(Media.setdisplay)

    type Inline end

    for D in :[Editor, Console].args
      @eval type $D end
      @eval let pool = @d()
        Media.pool(::$D) = merge(Media.pool(), pool)
        Media.setdisplay(::$D, T, input) = pool[T] = input
      end
    end

    setdisplay(Editor(), Any, Console())
    setdisplay(Console(), Any, Console())

    # Inline display

    link(x, file) = a(@d("data-file"=>file), x == nothing ? basename(file) : x)
    link(x, file, line::Integer) = link(x, "$file:$line")
    link(file, line::Integer...) = link(nothing, file, line...)

    render(::Inline, x::HTML; options = @d()) = stringmime(MIME"text/html"(), x)
    render(::Inline, x::Node; options = @d()) = stringmime(MIME"text/html"(), x)
