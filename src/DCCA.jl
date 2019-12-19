module DCCA

include("calculs.jl")
include("utils.jl")

"""
    rhoDCCA(x,y; box_start = 3, box_stop = div(length(x),10), nb_pts = 30)
Performs the DCCA analysis of `x` and `y`. The default analysis starts with a window size of 3 up to one tenth of the total length of `x` for statistical reasons.
returns the different window sizes used for the analysis, and the associated dcca coefficients.
"""
function rhoDCCA(data1::Array{Float64,1},data2::Array{Float64,1}; box_start = 3, box_stop = div(length(data1),10), nb_pts = 30)
    if length(data1) != length(data2)
        error("the two data series must have same length.")
    end
    if box_stop > div(length(data1),10)
        @warn "`Box_stop` parameter greater that 1/10 of data length. Results at large time scales might not make sense."
    end
    x = log_space(box_start,box_stop,nb_pts)
    y = dcca(data1,data2; box_start = box_start, box_stop = box_stop, nb_pts = nb_pts)
    return x, y
end

"""
    empirical_CI(x,y) --> points, critical_values
Extrapolates tables found in the litterature to provide a 95% confidence interval between `start` and `stop`.
The confidence interval represents the null hypothesis "no correlations".
"""
function empirical_CI(data_length; start = 4, stop = div(data_length,10))
    if stop > 256 #256 is the biggest window size found in litterature about confidence intervals.
        @warn "`stop` parameter is greater what can be found in the litterature.\n For Every point past 256, the confidence interval is linearly extrapolated."
    end
    points = collect(start:stop)
    critical_values = complete_CI(data_length, points)
    return points, critical_values
end

"""
    bootstrap_CI(x,y) --> lower, upper
Provides absolute bounds for the null hypothesis "no correlations" using a bootstrap procedure.
"""
function bootsrap_CI(x::Array{Float64,1},y::Array{Float64,1}; iterations::Int = 500)
    if length(x) != length(y)
        error("the two data series must have same length.")
    end
    lower, upper = zeros(iterations), zeros(iterations)
    for i in 1:iterations
        tmp = dcca(shuffle(x), shuffle(y))
        lower[i], upper[i] = minimum(tmp), maximum(tmp)
    end
    sort!(lower)
    sort!(upper)
    return lower[div(iterations,20)], upper[iterations-div(iterations,20)]
end

export rhoDCCA, rhoDCCA_CI

end


