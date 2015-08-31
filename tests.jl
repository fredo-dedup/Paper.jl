################### escher.jl  ###################

	cd("p:/documents/julia/paper")
	include("testserve2.jl")
	@async MyServer.launch(5573)

	# @spawn begin
	# 	include("testserve2.jl")
	# 	MyServer.launch(5560)
	# end

	5+6
	"abcd"




	MyServer.chunk(:start)
	MyServer.chunk(:start)
	MyServer.chunk(:23)
	MyServer.chunk(:end)
	MyServer.current, MyServer.torder

	using Escher

	MyServer.addtotile(vbox("end, end"))


	MyServer.addtotile(vbox("encadré") |> color("#f00"))
	MyServer.addtotile(vbox("encadré") |> border(solid, 1em, "#f00"))
	MyServer.addtotile(vbox("encadré") |> borderwidth(1px) |> bordercolor("#f00") |> borderstyle(solid))



	MyServer.addtotile(vbox("abcd"))


	import Base.Multimedia.writemime

	methods(writemime, (IO, MIME"text/plain", Float64))

############ markdown   ####################

	function writemime(io::IO, ::MIME"text/plain", md::Markdown.MD)
		MyServer.addtotile(md)
		Markdown.plain(io, md)
	end

	using Markdown

	md"""
	- test

	ceci est du *markdown*
	"""

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

	compose(sierpinski(5), linewidth(0.1mm), fill(nothing), stroke("black"))


	using Gadfly

	pl = plot(x=rand(10), y=rand(10), Geom.point, Geom.line)

	typeof(pl)

	MyServer.addtotile(pl |> borderwidth(1px) |> bordercolor("#f00") |> borderstyle(solid))
	MyServer.addtotile(pl |> shrink(2.))


	methods(writemime, (IO, MIME"text/plain", typeof(pl)))

	md"# chapter 45"
	h1("Chapter 45")

img = SVG("sierpinski.svg", 4inch, 4(sqrt(3)/2)inch)
draw(img, compose(sierpinski(8), linewidth(0.1mm), fill(nothing), stroke("black")))



	5+6
	"abcd";

	Escher.bestmime(456)

	A = [456 465 ; 4  46]
	Escher.bestmime(A)

	MyServer.addtotile("-------------")


	methods(writemime, (IO, MIME"text/plain", Any))

	Escher.table

	MyServer.@eval(begin 
		MyServer.mytiles = Escher.vbox("abcd")
		println(mytiles)
	end)

	MyServer.@eval mytiles
	eval(MyServer, :mytiles)
	MyServer.eval(:( mytiles = vbox(hbox("abcd", "et ta soeur")) ) )
	MyServer.eval(:( notify(updated) ) )


	MyServer.eval(:( mytiles = vbox("burp", "...", "hello" ) )) 
	MyServer.eval(:( notify(updated) ) )



	mytiles = nothing

	MyServer.mytiles

	MyServer.@eval quote
		push!(updated, "")
	end



############## mime types  ###################

	

