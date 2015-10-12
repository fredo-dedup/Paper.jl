############ Escher ################

	using Escher
	using Mux
	include(Pkg.dir("Escher", "src", "cli", "serve.jl"))
	cd(Pkg.dir("Escher", "examples")) # or any other directory
	escher_serve()

	### js pour scroller ###
	element = document.getElementById("divFirst")
	alignWithTop = true;
	element.scrollIntoView(alignWithTop);


	using Gadfly
	p = plot(x=rand(10), y=rand(10), Geom.point, Geom.line)
	draw(PNG("c:/temp/myplot.png", 12Gadfly.cm, 6Gadfly.cm), p)

#########  Graphes PyPlot  #######

	workspace()
	reload("Paper")
	reload("Compose")
	using Paper
	init()

	using Gadfly

	δ = 0.96
	4.06 * exp(0.96)
	4.06 * exp(-0.96)  #  1.54 / 10.71

	using Distributions
	reload("Distributions")

	N = 10000
	ns = rand(Poisson(1.54), N)
	as = rand(Multinomial(N, ))


	ddir = "P:/Documents/Julia/RWC"
	include(joinpath(ddir, "mods.jl"))

	Fit.init(1.54, 10.71)
	Fit.stats[:winA] / Fit.N  # 0.
	Fit.stats[:winB] / Fit.N  # 0.99996

	using PyPlot
	x = linspace(0,2*pi,1000); y = sin(3*x + 4*cos(2*x));
	p = plot(x, y, color="red", linewidth=2.0, linestyle="--")
	t = PyPlot.title("A sinusoidally modulated sinusoid")
	typeof(t)
	f = PyPlot.gcf()
	display(f)

	using Paper
	init()
	Paper.reset()
	@chunk deb


	Paper.Elem(:div, stringmime(MIME"text/svg"(), f))
	5+6

	drawing
	Paper.Escher.drawing(f)
	whos(Paper.Escher)

	pygui(true)

	sio = IOBuffer()
	writemime(sio, MIME"image/svg+xml"(), f)
	takebuf_string(sio)

	Tile(Paper.Elem(:svg, takebuf_string(sio)))

	convert(Tile, takebuf_string(sio))
	convert(Tile, takebuf_string(sio))

	Paper.Escher.AnyWrap(f)

	type TPyPlot <: Tile


	Paper.Escher.bestmime(f)
	stringmime(MIME"text/svg"(), f)
	stringmime(MIME"image/png"(), f)
	mimewritable(MIME"text/svg"(), f)
	mimewritable(MIME"image/png"(), f)
	Tile(f)
	methods(convert, (Tile, Any))


	@require Compose begin
    @api drawing => ComposeGraphic <: Tile begin
        arg(width::Compose.Measure)
        arg(height::Compose.Measure)
        curry(graphic::Any) # Either a plot or a compose node
    end
    drawing(p) =
        drawing(Compose.default_graphic_width,
                Compose.default_graphic_height, p)

    convert(::Type{Tile}, p::Compose.Context) =
        drawing(p)

    render(d::ComposeGraphic, state) = begin
        backend = Compose.Patchable(
            d.width, d.height
        )
        Elem(:div, Compose.draw(backend, d.graphic), className="graphic-wrap")
    end

	using Compose

	function golden_rect(n::Int)
	    if n == 0 return context() end
	    c = Compose.compose(context(), rectangle(), fill(LCHab(90, 80, 70 - 15n)))
	    Compose.compose(c, context(units=UnitBox(0, -1/φ, 1h, 1/φ), rotation=Rotation(π/2, 0, 1)),  golden_rect(n - 1))
	end

	draw(Compose.SVG("c:/temp/golden_rect.svg", φ * 3Compose.inch, 3Compose.inch),
	    Compose.compose(golden_rect(2), fill(nothing), linewidth(0.2Compose.mm)))

		




	using Escher
	include(Pkg.dir("Escher", "src", "cli", "serve.jl"))
	cd(Pkg.dir("Escher", "examples")) # or any other directory
	@async escher_serve()


#########  Paper, live graph (WIP)  #############
	using Base.Markdown
	reload("Paper") ; p = Paper
	# using Paper
	# using Gadfly
	# Paper.rewire(Gadfly.Plot) do p
	#     Paper.addtochunk(convert(Tile, p))
	# end

	p.init(5563)
	p.@chunk header
	p.title(1, "Test")
	typeof(z)
	"abcde"
	md"abcd **sfdsf** qsdfqsdf"

	isa(z, p.Tile)

	p.@chunk plot
	p.chunk(:plot)

	using PyPlot

	x = linspace(0,2*pi,1000); y = sin(3*x + 4*cos(2*x));
	PyPlot.plot(x, y, color="red", linewidth=2.0, linestyle="--")
	title("A sinusoidally modulated sinusoid")

	123

	fig = gcf()

	p.Escher.bestmime(fig)

	p.mimewritable(MIME"image/svg+xml"(), fig)

	import Base.Multimedia.mimewritable
	mimewritable(::MIME"image/svg+xml", ::PyPlot.Figure) = true

	PyPlot.svg(true)

	p.reset()

    p.plan[:plot] = [];
    p.plan[:header] = []
    p.notify(p.updated)
	p.plan

	error(length(p.plan[:plot]))
	p.addtochunk(12)

	p.rewire(PyPlot.Figure)

	fig

	using Compose
	function sierpinski(n)
	    if n == 0
	        Compose.compose(context(), polygon([(1,1), (0,1), (1/2, 0)]))
	    else
	        t = sierpinski(n - 1)
	        Compose.compose(context(),
	                (context(1/4,   0, 1/2, 1/2), t),
	                (context(  0, 1/2, 1/2, 1/2), t),
	                (context(1/2, 1/2, 1/2, 1/2), t))
	    end
	end

	c = sierpinski(3);

    p.plan
    p.torder
    p.current
    p.active
    p.sock
    p.serverid
    p.global_style


	Nb = 100
	μAs, μBs = Array(Float64, 0), Array(Float64, 0)

	μA, μB = 4., 4.
	ll = flik(μA, μB)
	naccept = 0
	for iter in 1:100
		μA₁ = μA + rand(Normal(0,0.1))
		μB₁ = μB + rand(Normal(0,0.1))
		u = rand()
		ll₁ = flik(μA₁, μB₁)
		if ll₁-ll >= rand()
			μA, μB, ll = μA₁, μB₁, ll₁
			push!(μAs, μA) ; push!(μBs, μB) ; 
			naccept += 1
		end
		if iter % 10 == 0
			push!(update, true)
		end
	end

	plot(x=μAs, y=μBs),
	         	  Scale.x_continuous(minvalue=0,maxvalue=8),
	              Scale.y_continuous(minvalue=0,maxvalue=8)) 

	p.@chunk plot
	p.plan[:plot] = []
	p.notify(p.updated)

	x = [1.]
	y = [0.]

	update = p.Input(true)
	p.stationary(update) do _
		PyPlot.plot(x, y, color="blue", linewidth=1.0, linestyle="-");
		gcf()
	end

	x₀, y₀ = 1., 0.
	for i in 1:10
		x₀ += 1.;
		y₀ = sin(x₀);
		push!(x, x₀);
		push!(y, y₀);
		push!(update, false);
		sleep(0.5)
	end
