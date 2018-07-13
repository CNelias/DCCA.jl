module rho_DCCA

include("calculs.jl")

function rho_DCCA(data1,data2,box_b::Int,box_s::Int,nb_pt::Int,titre::String)
    x =  log_space(box_b,box_s,nb_pt)
    y = rho(data1,data2,box_b,box_s,nb_pt; fit_type = "polynomial")
    #fig = figure("",figsize=(3,5))
    plot(x,y,"bo-",markersize = 4); 
    #a = linreg(x,y)[2]
    #b = linreg(x,y)[1]
    #plot(x,a*x + b, color = "black",linestyle = ":", label = "linear fit")
    title(titre)
    legend()
    xlabel("Window size s (notes)")
    xscale("log")
    #yscale("log")
    #ylim(0.01,10)
    ylabel(L"$\rho_{DCCA}(s)$")
end

function rho_DCCA(data1,data2,box_b::Int,box_s::Int,nb_pt::Int)
    x =  log_space(box_b,box_s,nb_pt)
    y = rho(data1,data2,box_b,box_s,nb_pt; fit_type = "polynomial")
    return y
end

export rho_DCCA

end
