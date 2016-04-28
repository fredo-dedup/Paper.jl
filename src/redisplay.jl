# submodule here to segregate the 'render()' of Escher from the one of Media
module Redisplay

    using Media, Atom
    import Media: render

    type MauritsDisplay <: Display end
    const md = MauritsDisplay()

    @media MauritsThing
    setdisplay(MauritsThing, md)

    function rewire(func::Function, t::Type)
      media(t, MauritsThing)
      @eval function render(::MauritsDisplay, x::$t)
            ($func)(x)
            string(typeof(x))
          end

      @eval render(::Atom.Editor, x::$t)  = nothing
      # @eval render(::Atom.Console, x::$t) = nothing

    end

    isrewired(t::Type) = getdisplay(t, Media._pool) == md

end

import .Redisplay: rewire, isrewired

rewire(t::Type)  = rewire(addtochunk, t)

macro rewire(args...)
    for a in args
        t = try
              eval(current_module(), a)
            catch e
              error("can't evaluate $a, error $e")
            end
        isa(t, Type) || error("$a does not evaluate to a type")
        rewire(t)
    end
end

# by default Tiles and Markdown will be forwarded
@rewire Escher.Tile # Base.Markdown.MD
