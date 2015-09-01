############### Paper tests  ###################

	cd("p:/documents/julia/paper")
	include("src/Paper.jl")

	tid = Paper.launch()

	# t = @async run(server, 3000)
	# ...
	# ex = InterruptException()
	# Base.throwto(t, ex)
	# close(http.sock) # ideally HttpServer would catch exception to cleanup

	
	Paper.chunk(:start)
	"abcd"
	5+6


	mf(x) = x*exp(-x*x)
	mf(4.5)

	a = "abcd" |> Paper.fontweight(700)

	using Markdown

md"""
	 - el 1
	 - el 2

# titre h1

	 $e^2$
"""


	fm = Paper.tex("e^2")

	Escher.slider(0:10)


	"rouge"   |> Paper.fontcolor("#f00")
	"encadré" |> Paper.border(Paper.solid, 1Paper.em, "#f00")
	"encadré" |> Paper.borderwidth(1Paper.px) |> Paper.bordercolor("#f00") |> Paper.borderstyle(Paper.solid)


############  compose  ######################

	using Compose

	function sierpinski(n)
	    if n == 0
	        compose(context(), polygon([(1,1), (0,1), (1/2, 0)]))
	    else
	        t = sierpinski(n - 1)
	        compose(context(),
	                (context(1/4,   0, 1/2, 1/2), t),
	                (context(  0, 1/2, 1/2, 1/2), t),
	                (context(1/2, 1/2, 1/2, 1/2), t))
	    end
	end

	compose(sierpinski(3), linewidth(0.3mm), fill(nothing), stroke("#4e4"))

############  gadfly  ######################

	using Gadfly

	pl = plot(x=rand(10), y=rand(10), Geom.point, Geom.line)

	Paper.rewire(Gadfly.Plot) do p
		Paper.addtochunk(convert(Paper.Tile, p))
	end

	pl |> Paper.caption("ceci est un beau graphe")


	Paper.vbox(pl, Paper.caption("ceci est un beau graphe")) |> Paper.packacross(Paper.center)


############ Arrays  #######################

	A = [456 465 ; 4  46]
	Escher.bestmime(A)

	MyServer.addtotile("-------------")


	methods(writemime, (IO, MIME"text/plain", Any))

	Escher.table

	

