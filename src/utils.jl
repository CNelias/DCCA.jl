using Interpolations

#ci_keys is the parameter describing the length of the time series to study.
ci_keys = Int[250,500,1000,2000,4000,8000]
#ci-points describes the window sizes at whcih the critical values are given (in function of ci_keys).
ci_points = Int[4 ,8, 16, 32, 64, 128, 256]
# ci_values stocks the critical values describing the 95% confidence interval depending on the ci_keys parameter.
ci_values = [Float64[0.129, 0.156, 0.212, 0.305, 0.448], Float64[0.091, 0.109, 0.147, 0.210, 0.302, 0.447], Float64[0.064, 0.077, 0.104, 0.146, 0.208, 0.306, 0.449], Float64[0.045,0.054,0.073,0.102,0.145,0.209,0.304], Float64[0.032,0.039,0.052,0.072,0.102,0.145,0.209], Float64[0.023, 0.027, 0.037, 0.051, 0.072, 0.102, 0.146]]

"""
    nearest_neighbour(value, listOfValues) --> (nn, index)
finds and returns the nearest neighbour to `value` in `listOfValues`, as well as the index of it in `listOfValue`.
"""
function nearest_neighbour(value, listOfValues)
    index_nn = findmin(abs.(listOfValues .- value))[2] #index of the nearest neighbour
    nn = listOfValues[index_nn] #value of the nearest neighbour
    return nn, index_nn
end

"""
    interpolate(x,y) -> interpolation_function
creates and return an interpolation function working for any point.
"""
function interpolate(x,y)
    interpolation_function = LinearInterpolation(x,y, extrapolation_bc = Line())
    return interpolation_function
end

"""
    complete_CI(data_length, points)
returns the complete interpolated 95% confidence intervals for all the points in `points`.
"""
function complete_CI(data_length, points)
    partial_CIs = ci_values[nearest_neighbour(data_length, ci_keys)[2]]
    total_CI = interpolate(ci_points[1:length(partial_CIs)], partial_CIs)(points)
    return round.(total_CI, digits = 3)
end
