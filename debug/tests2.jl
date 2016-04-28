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

#########  PyPlot  #############
	workspace()
	import PyPlot
	using Paper

	import Base.Multimedia.mimewritable
	mimewritable(::MIME"image/svg+xml", ::PyPlot.Figure) = true
	@rewire Main.PyPlot.Figure

	@session PyPlot2 pad(1em)

	@chunk plot
	x = linspace(0,2*pi,1000)
	y = sin(cos(0.2x.^2))
	PyPlot.plot(x, y, color="red", linewidth=1.0, linestyle="--")
	PyPlot.title("A sinusoidally modulated sinusoid")
	PyPlot.gcf()
	PyPlot.close()

	@chunk plot2

	@chunk plot3 fillcolor("yellow")
	sig = Input(1.0)
	stationary(sig) do f
		PyPlot.close()
		x = linspace(0,2*pi,1000); y = sin(cos(f*x.^2));
		p1 = PyPlot.plot(x, y, color="red", linewidth=1.0, linestyle="--")
		p2 = PyPlot.title("A sinusoidally modulated sinusoid")
		PyPlot.gcf()
	end

	push!(sig, 0.5)
	push!(sig, 0.2)

	Paper.currentChunk

	Paper.currentSession

	workspace()
	using Paper
	whos()


	cm = PyPlot.ColorMap("Spectral")
	typeof(cm)

	Paper.bestmime(cm)
	mimewritable(::MIME"image/svg+xml", ::PyPlot.Figure)

	display(typeof(cm))

	@rewire Main.PyPlot.ColorMap
	cm

	methods(display, (PyPlot.Figure,))

#########  Compose  #############
	using Compose
	Paper.@rewire Compose.Context

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

	@chunk plot
	c = sierpinski(3);
	c

##############################################
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

############### animated graph  #########################
	whos()
	using Paper
	@session anim
	@chunk header
	md"*Animated* graph **!**"

	@chunk plot

	x = [1.]
	y = [0.]

	update = Input(true)
	stationary(update) do _
		p = PyPlot.plot(x, y, color="blue", linewidth=1.0, linestyle="-")
		# gcf()
		# length(x)
	end

	# Paper.currentSession.chunks

	x₀, y₀ = 1., 0.
	for i in 1:10
		x₀ += 1.;
		y₀ = sin(x₀);
		push!(x, x₀);
		push!(y, y₀);
		push!(update, false);
		sleep(0.2)
	end
