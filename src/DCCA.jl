module DCCA

include("calculs.jl")

"""
    rhoDCCA(x,y; box_start = 3, box_stop = div(length(x),10), nb_pts = 30)

Performs the DCCA analysis of `x` and `y`. The default analysis starts with a window size of 3 up to one tenth of the total length of `x` for statistical reasons.

returns the different window sizes used for the analysis, and the associated dcca coefficients.
"""
function rhoDCCA(data1::Array{Float64,1},data2::Array{Float64,1}; box_start = 3, box_stop = div(length(data1),10), nb_pts = 30)
    x = log_space(box_start,box_stop,nb_pts)
    y = dcca(data1,data2; box_start = box_start, box_stop = box_stop, nb_pts = nb_pts)
    return x, y
end

function rhoDCCA_CI(x,y)
    lower, upper = zeros(500), zeros(500)
    for i in 1:500
        tmp = dcca(shuffle(x), shuffle(y))
        lower[i], upper[i] = minimum(tmp), maximum(tmp)
    end
    sort!(lower)
    sort!(upper)
    return lower[25], upper[475]
end

export rhoDCCA, rhoDCCA_CI

end


