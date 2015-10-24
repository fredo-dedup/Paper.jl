
using Media

import Media: render


type MauritsDisplay end

const md = MauritsDisplay()

# methods(setdisplay)
for t in [Tile, Base.Markdown.MD] # t = Tile
  setdisplay(t, md)
  oldfunc = methods(render, (Atom.Editor, t))[1].func

  eval( quote
          function render(::Atom.Editor, x::$t, $md)
            addtochunk(x)
          end
        end)
end
  # scan every input for type t


function render(::Atom.Editor, x::Tile, ::MauritsDisplay)
  addtochunk(x)
end

export render

methods(render, (Atom.Editor, Any, MauritsDisplay))

meths = methods(render, (Any, t, Any))
setdisplay(Foo, MyD())

render(::MyD, x::Foo) = "abcd"
render(::Any, x::Foo, ::MyD) = "xyz"
render(::Atom.Editor, x::Foo) = "xyz" # ça marche

methods(render, (Any, Foo))

methods(render)

render(MyD(), Foo(12))
