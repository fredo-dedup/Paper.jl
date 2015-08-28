
import Base.Multimedia.display

type T1
	a
end


t = T1(45)
t.a

type MyDisplay <: Display ; end

MyD = MyDisplay()

function display(d::MyDisplay, ::MIME"text/plain", x::Float64)
	println("Float $x  seen !!")
end
display(d::MyDisplay, x::Float64) = display(d, MIME"text/plain"(), x)

function display(d::MyDisplay, ::MIME"text/plain", x::AbstractString)
	println("String !! $x")
end
display(d::MyDisplay, x::AbstractString) = display(d, MIME"text/plain"(), x)



pushdisplay(MyD)
popdisplay()

Base.Multimedia.xdisplayable(MyD, 12.4)
display(MyD, 12.4)
Base.Multimedia.xdisplayable(MyD, "bcd")
display(MyD, "heehaw!")


show(io, t::T1) = display()

########### md 
	using Markdown
	import Base.show

	mds = Markdown.@md_str "## test"
	mds = md"""
	# Heading 1
	"""
	
	show(io::IO, md::Markdown.MD) = println("md found")

	import Base.writemime
	writemime(io::IO, ::MIME"text/plain", md::Markdown.MD) = print(io, "seklfhqkdfh")

	mds

	function writemime(io::IO, ::MIME"text/plain", x)
		println(io, "I was here")
		Base.showlimited(io, x)
	end

	215
	456.4
	"abcde"
	[4.,456]

	println(mds)
	methods(mimewritable)
	typeof(mds)
	methods(writemime, (IO, MIME"text/plain", Markdown.MD))
	methods(writemime, (IO, MIME"text/plain", Float64))
	methods(show, (Markdown.MD,))

12.4

display(12.4)

Base.Multimedia.displays

45.6


Base.Multimedia.displays



##########  reference 
	# it is convenient to accept strings instead of ::MIME
	display(d::Display, mime::String, x) = display(d, MIME(mime), x)
	display(mime::String, x) = display(MIME(mime), x)
	displayable(d::Display, mime::String) = displayable(d, MIME(mime))
	displayable(mime::String) = displayable(MIME(mime))

	# simplest display, which only knows how to display text/plain
	immutable TextDisplay <: Display
	    io::IO
	end
	display(d::TextDisplay, M::MIME"text/plain", x) = writemime(d.io, M, x)
	display(d::TextDisplay, x) = display(d, MIME"text/plain"(), x)

	import Base: close, flush
	flush(d::TextDisplay) = flush(d.io)
	close(d::TextDisplay) = close(d.io)



#### sockets

	c1 = connect("abcdtest")
	listen(2000)

	listen("testpaper")

	@async begin
         server = listen("testsocket")
         while true
           sock = accept(server)
           println("Hello World\n")
         end
    end

    connect(2001)

    pap = connect(2020)
    write(pap, "ceci est une ligne\n")
	println(pap, "et une autre ligne")
	close(pap)



	function writemime(io::IO, ::MIME"text/plain", x)
		println(pap, x)
		Base.showlimited(io, x)
	end

	5+6
	ones(10)
	pap

	π
	cos(0.123)

	using Gadfly

	res = plot(sin, 0, 10)
	typeof(res)

	methods(writemime, (IO, MIME"text/plain", typeof(res)))
	methods(writemime, (IO, Any, typeof(res)))
	 writemime(io::IO,m::String,x) at multimedia.jl:41                                                             
	 writemime(io::IO,::MIME{symbol("text/plain")},p::Plot) at D:\frtestar\.julia\v0.3\Gadfly\src\Gadfly.jl:929    
	 writemime(io::IO,::MIME{symbol("text/plain")},x) at In[364]:2                                                 
	 writemime(io::IO,m::MIME{symbol("text/html")},p::Plot) at D:\frtestar\.julia\v0.3\Gadfly\src\Gadfly.jl:895    
	 writemime(io::IO,m::MIME{symbol("image/svg+xml")},p::Plot) at D:\frtestar\.julia\v0.3\Gadfly\src\Gadfly.jl:904

	"cos test $res"

	md"# title"

	cod = open("c:/temp/mini.jl", "w")
	write(cod, """
		md"# title"
		""") # "
	close(cod)

	include("c:/temp/mini.jl")
	methods(include)


	log(-5)

	IPv4(0)

	showall(subtypes(Tile))

####################################################

	dat0 = open(deserialize, fdat, "r")
	fdat = "c:/temp/ftest.dat"
	open(f -> serialize(typeof(res), SVG(res)), fdat, "w")

	fieldnames(res)
	res = Compose.compose(Compose.context(), Compose.polygon([(1,1), (0,1), (1/2, 0)]));
	Compose.SVG(fdat, res, 4inch, 4(sqrt(3)/2)inch)

	draw(SVG(STDOUT,4inch,4inch), res)

	out = IOBuffer()
	draw(SVG(out,4inch,4inch), res)
	showall(methodswith(typeof(out)))
	flush(out)
	takebuf_array(out)
	show(out)

	methods(SVG)
	typeof(res)
	serialize(IOBuffer, res)

	@async begin
         server = listen("testsocket")
         while true
           sock = accept(server)
           println("accepted\n")
           dat = readavailable(sock, )
         end
    end

