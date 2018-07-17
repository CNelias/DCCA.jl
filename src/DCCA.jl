module DCCA

using PyPlot
include("calculs.jl")

function rhoDCCA(data1,data2,box_b::Int,box_s::Int,nb_pt::Int,plot::Bool)
    x = log_space(box_b,box_s,nb_pt)
    y = dcca(data1,data2,box_b,box_s,nb_pt; fit_type = "polynomial")
    if plot == false
        return y
    elseif plot == true
        plot(x,y,"bo-",markersize = 4)
        title("DCCA coefficients analysis of data")
        legend()
        xlabel("Window size s (notes)")
        xscale("log")
        ylabel(L"$\rho_{DCCA}(s)$")
    end
end
export rhoDCCA
end
  
