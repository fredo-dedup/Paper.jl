############################################################################
#   Compilation function : compile()
############################################################################

methods(include)



script = IOBuffer("""
  println("abce")
  a,c = 3, 1
  a = a +
    c
  4+5
   """)


script = IOBuffer("""
 using Paper

 a + 3

 @session compilation
  @newchunk test
 container(3em, 3em) |> fillcolor("tomato")
 4+5

  """)




compile(script)


function compile(filepath::IO)
  emod = Module(gensym())

  hit_eof = false
  counter = 0
  while true
      line = ""
      ast = nothing
      interrupted = false
      while true
          try
              line *= readline(script)
              counter += 1
          catch e
              if isa(e,EOFError)
                  hit_eof = true
                  break
              else
                  rethrow()
              end
          end
          ast = Base.parse_input_line(line)
          (isa(ast,Expr) && ast.head == :incomplete) || break
      end
      if !isempty(line)
          print(counter, " : ", ast)
          ret = try
                  eval(emod, ast)
                catch err
                  println("at line $counter : ")
                  rethrow()
                end
          println(ret)
          if ret != nothing
            emod.@eval Paper.Redisplay.render(Paper.Redisplay.md, $ret)
          end
      end
      println()
      ((!interrupted && isempty(line)) || hit_eof) && break
  end
end
