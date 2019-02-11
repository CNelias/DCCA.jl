module DCCA

include("calculs.jl")

function rhoDCCA(data1,data2,box_b::Int,box_s::Int,nb_pt::Int)
    x = log_space(box_b,box_s,nb_pt)
    y = dcca(data1,data2,box_b,box_s,nb_pt; fit_type = "polynomial")
    return x,y
end

export rhoDCCA

end
  
