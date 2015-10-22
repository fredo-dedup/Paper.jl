########### basic tests  ##################
	using Base.Markdown
	workspace()
	reload("Paper") ; p = Paper
	using Paper

	@session abcd4
	@session

	current_task()
	p.serverid

	p.@chunk header
	p.@chunk
	p.mute_writemime
	p.currentChunk
	123
	title(1,"test")

	methods(writemime, (IO, MIME{symbol("text/plain")}, Any))
	p.@rewire Number

	p.container(10em, 15em) |> p.fillcolor("tomato")


	Base.Multimedia.displays

	@chunk plot5

	Paper.chunk(:abcd)
	Paper.chunk(gensym("abcd"))

	@chunk
	@chunk plot1 fontcolor("tomato")
	plaintext("kljhazeflh")
	tex("\\sum_2^n")

	plaintext(Paper.currentSession.chunknames)
	plaintext(Paper.currentSession.chunknames) |> fontcolor("tomato")
	
	@chunk
	@chunk font fontsize(1em)
	plaintext(Paper.currentSession.chunknames)

	@chunk font2 fontsize(3mm) fontcolor("tomato") border()
	plaintext(Paper.currentSession.chunknames)

	plaintext(Paper.currentSession.chunkstyles) |> fontsize(2em)
	plaintext(Paper.currentSession.chunkstyles) |> fontcolor("tomato")

	plaintext(Paper.sessions)


	methods(fontsize)


	Paper.currentSession.chunknames

########### layout  #####################
	using Paper
	@session abcd4

	@chunk c1 fontcolor("tomato") fontsize(5mm)
	plaintext("coucou les amis")
	tex("x=e^{-x} P(x)")
	title(2, "niok")
	tex("x=e^{-x} P(x)") 
	plaintext("coucou les amis")

	@chunk c2 wrap height(10em)
	hline()
	title(1, "yoo hoo") |> width(5em)
	hline()

	@chunk c3 pad(1em) maxheight(10em) clip()
	plaintext("coucou les amis qs dqsdq sdqsdqsdqsd qsdqs dqs dqsdqsd qsdqs qsdq qsdqs qsdqsdsq") |> width(30cent)

	@chunk c3  maxheight(10em) clip() pad(1em)
	plaintext("coucou les amis qs dqsdq sdqsdqsdqsd qsdqs dqs dqsdqsd qsdqs qsdq qsdqs qsdqsdsq")

	@session tests2 pad(1em)

	@chunk c1 maxheight(10em) width(20em) clip() fillcolor("lightgrey") 
	plaintext("coucou les amis qs dqsdq sdqsdqsdqsd qsdqs dqs dqsdqsd qsdqs qsdq qsdqs qsdqsdsq")

	@chunk c4 width(10em) height(10em) flow(vertical)  wrap  fillcolor("lightyellow")

	plaintext("coucou les amis")

	@chunk c5 fillcolor("lightblue") flow(vertical) height(10em) packlines(axisstart)
	vbox(["ab", "cd", "qk", "jsh", "qs", "dlkj", "qsd"]) |> 
		wrap |>
		height(8em) 

	flow(horizontal, ["ab", "cd", "qk", "jsh", "qs", "dlkj", "qsd"]) |> 
		fontcolor("tomato")

	methods(packitems)


	plaintext("coucou les amis") |> width(10em)  # marche
	[plaintext("coucou les amis"), plaintext("yo")] |> width(10em)
	# marche pas : no method matching convert(::Type{Escher.Tile}, ::Array{Escher.Leaf,1})

	plaintext("coucou les amis") |> wrap 
	# marche pas : no method matching convert(::Type{Escher.FlexContainer}, ::Escher.Leaf)
	[plaintext("coucou les amis"), plaintext("yo")] |> wrap
	# marche pas : no method matching convert(::Type{FlexContainer}, ::Array{Escher.Leaf,1})

	plaintext("coucou les amis") |> vbox  # ok
	[plaintext("coucou les amis"), plaintext("yo")] |> vbox  # ok

	t1 = vbox(plaintext("coucou les amis"))
	isa(t1, Tile)  # true
	isa(t1, Escher.FlexContainer) # true


###########   display ???  ###########################

	methods(display)
	ds = Base.Multimedia.displays
	 # TextDisplay(IOStream(<fd 10>))
	 # IPythonDisplay.InlineDisplay()

	display(ds[2], MIME"text/plain"(), 2) # rien
	display(ds[1], MIME"text/plain"(), 2) # rien

	type Foo ; x ; end

	import Base.Multimedia: writemime, display

	function writemime(io::IO, mt::MIME"text/plain", x::Foo)
		Base.show_backtrace(STDOUT, backtrace())
		println("wm : $x")
	end

	immutable PaperDisplay <: Display
	end

	display(d::PaperDisplay, M::MIME"text/plain", x) = println("Paper: $x")
	display(d::PaperDisplay, x) = display(d, MIME"text/plain"(), x)

	pd = PaperDisplay()
	pushdisplay(pd)

	412

	display(d::PaperDisplay, M::MIME"text/plain", x::Foo) = println("Paper: $(x.x)")
	display(d::PaperDisplay, x::Foo) = display(d, MIME"text/plain"(), x)

	Foo(412)



	Foo(2)

                    # println("$io,   $(io==STDOUT))")
                    # println("interact : $(isinteractive())")
                    # println("task : $(current_task())")
                    current_task()==currentTask && ($func)(x) # send only if interactive task
                    ($meth)(io, mt, x)
                end 


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
	workspace()
	import PyPlot
	using Paper

	import Base.Multimedia.mimewritable
	mimewritable(::MIME"image/svg+xml", ::PyPlot.Figure) = true
	@rewire Main.PyPlot.Figure

	@session PyPlot2 pad(1em)

	@chunk plot
	x = linspace(0,2*pi,1000); y = sin(cos(0.2x.^2));
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

############### signals hell  #########################

	workspace()
	reload("Paper") ; using Paper

    @loadasset "widgets"

    @session signals pad(1em)
    @chunk header
    title(1, "Signals")

    @chunk signal


    abᵗ  = Input(100.)

    lift(println, abᵗ)

    push!(abᵗ, 12)
    push!(abᵗ, 41)

    slider(1:1000, value=100) >>> abᵗ

    value(abᵗ)

    subscribe(slider(1:1000), abᵗ)

    methods(subscribe)

    stationary(abᵗ) do x
        plaintext("aaaa : $x")
    end

    md"les sliders ne mettent pas à jour les signals associés"
    md"mais les Tiles répondent bien aux signaux"

    sig = Input(12)
    slider(1:100, value=15) >>> sig
    lift(println, sig)

    push!(sig, 32)

    stationary(abᵗ) do x
        slider(1:1000, value=x)
    end

    v1 = slider(1:1000);
    sig2 = Input(12)
    v2 = slider(1:1000)  >>> sig2;

    typeof(v1) # Escher.Slider
    isa(v1, Tile) # true
    isa(v1, Signal) # false

    typeof(v2) # Escher.Subscription
    isa(v1, Tile) # true
    isa(v1, Signal) # false

    Paper.currentChunk

