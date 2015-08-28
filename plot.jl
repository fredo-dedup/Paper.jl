using Gadfly

t0_	    = Input(0.)
tx0_	= Input(0.)
dur_	= Input(2.)
durt_   = Input(0.5)
cur_    = Input(0.)
itraxx_ = Input(1.)
 
### model description
	pdraw  = [0.5, 100., 4.] 
	pamort = [0.85, 0.25]
	psurv  = [0.3679, 0.0498, 5., -2, -3]

    function classic(h, t0, tx0, dur, durt, cur, itraxx) # x = vec(vars2[1210,:])
        α, β, k = pdraw
        dt0 = t0     * dur / (durt+0.01)
        dt  = (t0+h) * dur / (durt+0.01)
        tx = 1 - (1-tx0) * exp(-α*(dt-dt0) - β*(dt^(k+1)-dt0^(k+1))/(k+1))

        ah = h * dur
        amort = 1. + (pamort[1] - 1) * min(1., ah / pamort[2])

        surv = 0.
        if t0+h <= 1.
            λeff, λmat, α0, αcurr, αitr = psurv
            αeff0 = exp(α0 + αcurr*cur + αitr*itraxx)
            αeff = αeff0 / (1.+αeff0)
            αmat = 1.    / (1.+αeff0)

            seff(a) = exp(-a/λeff)
            smat(a) = 1 - exp((a-1)/λmat)
            
            snorm(t, fs) = (fs(t) - fs(1)) / (fs(0) - fs(1))
            spond(t)     = αeff*snorm(t, seff) + αmat*snorm(t, smat)

            surv = spond(t0+h) / spond(t0)
        end

        tx * amort * surv
    end
	# classic(0.5,0.,0.,10,2,1,1)


function main(window)
    push!(window.assets, "widgets")

    lift(t0_, tx0_, dur_, durt_, cur_, itraxx_) do t0, tx0, dur, durt, cur, itraxx
        vbox(h1("Bridges Loans (modèle classique)"),
        	 list([
	             hbox("Set t0"   |> width(10em)             , slider(0:.01:1, value=t0)  >>> t0_   ) |> packacross(center) ,
	             hbox("Set tx0"   |> width(10em)            , slider(0:.01:1, value=tx0) >>> tx0_  ) |> packacross(center) ,
	             hbox("Set duration"  |> width(10em)        , slider(0:.1:5, value=dur)  >>> dur_  ) |> packacross(center) ,
	             hbox("Set draw period"  |> width(10em)     , slider(0:.1:5, value=durt) >>> durt_ ) |> packacross(center) ,
	             hbox("Set currency USD"   |> width(10em)   , checkbox(cur)              >>> cur_  ) |> packacross(center) ,
	             hbox("Set itraxx" |> width(10em) , slider(0.1:.01:4., value=itraxx) >>> itraxx_) |> packacross(center)
	             ] )  ,
        	 hline(), 
             plot(x -> classic(x, t0, tx0, dur, durt, cur, itraxx), 0., 1.2,
             	  Scale.y_continuous(minvalue=0, maxvalue=1)) |> grow(5.)
             	  ) |> shrink(2.) |> pad(2em) # |> packitems(center)
    end
end
