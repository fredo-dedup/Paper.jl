using Paper
@session compilation
@newchunk test
plaintext("current_module() : $(current_module())")
@newchunk abcd vbox fillcolor("lightgray")
t = container(100cent, 10px) |> fillcolor("tomato");
plaintext(4+5)
