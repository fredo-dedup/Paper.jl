########### basic tests  ##################
	using Base.Markdown
	workspace()
	reload("Paper")
	using Paper

	p.@session abcd3

	current_task()
	p.serverid

	p.@chunk header
	p.@chunk
	p.mute_writemime
	p.currentChunk
	123
	p.title(1,"test")

	methods(writemime, (IO, MIME{symbol("text/plain")}, Any))

	p.@rewire Number

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

	4456
	5+6
	writemime(STDOUT, MIME"text/plain"(), 12)
	p.currentChunk
	3
	12
	1

	methods(writemime, (IO, MIME"text/plain", Number))


	p.fontsize(10)

	p.addtochunk([5,56,8])

	call(::Escher.Flow{Escher.Vertical})
	methods(call, (Escher.Flow, Any))

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
	using PyPlot

	import Base.Multimedia.mimewritable
	mimewritable(::MIME"image/svg+xml", ::PyPlot.Figure) = true
	@rewire Main.PyPlot.Figure

	@session PyPlot
	@chunk plot
	x = linspace(0,2*pi,1000); y = sin(cos(0.2x.^2));
	p1 = PyPlot.plot(x, y, color="red", linewidth=1.0, linestyle="--")
	p2 = PyPlot.title("A sinusoidally modulated sinusoid")
	gcf()

	workspace()
	using Paper
	whos()

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

############### layout  #########################

	@chunk plot

	hbox(hskip(1em),
		 vbox(vskip(10em) |> width(5em)) |> borderwidth(1px) |> bordercolor("#e44") |> borderstyle(dashed),
		 hskip(1em))

	@chunk plot2 fontcolor("#499")
	Paper.title(2, "hei ho") |> fontcolor("#499")

	Paper.currentSession.chunks[3]
	Paper.currentSession.chunkstyles

	@chunk plot5