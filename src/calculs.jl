using Polynomials
using StatsBase, Random

export dcca, log_space


"""
    log_space(start, stop, num)

Returns a linear spacing in loglog scale. The parameter `start` and `stop` define the range and `num` corresponds to the number of desired points.
"""
function log_space(start::Int,stop::Int,num::Int)
    spacing = map(x -> round(Int,x), exp10.(range(log10(start), stop=log10(stop), length=num)))
    return sort(unique(spacing))
end

"""
    partitioning(x, box_size; overlap = div(box_size,2))

Partitions `x` into several segment of length `box_size`. The default behavior is that the windowed data have a 50% overlap.
To change this, change the `overlap` parameter.

returns an array of size (n,box_size), n being the total number of segments.
"""
function partitioning(x::Array{Float64,1},box_size::Int64; overlap::Int = box_size - 1)
    nb_windows = div(length(x) - box_size, box_size - overlap) + 1
    partitionned_data = zeros(nb_windows, box_size)
    compteur = 1
    for i in 0:box_size - overlap:(length(x) - box_size)
        for j in 1:box_size
            partitionned_data[compteur,j] = x[i+j]
        end
        compteur += 1
    end
    return partitionned_data
end

"""
    detrending_poly(x::Array{Float64,1}, order::Int)

Performs a polynomial detrending of `values`. 'order' controls the order of the polynomial to use.
"""
function detrending_poly(values::Array{Float64,1}, order::Int)
    position = collect(1:length(values))
    f = Polynomials.fit(position,values,order)
    return values .- f.(position)# polyval(f,position)
end

"""
    linear detrending of 'values'
"""
function detrending(values::Array{Float64,1})
    x = collect(1:length(values))
    X = hcat(ones(length(values)),x)
    A = (X'*X)\X'*values
    return values .- (x.*A[2] .+ A[1])
end


function integrate(x::Array{Float64,1})
    return cumsum(x)
end

"""
    dcca(x,y; box_start = 3, box_stop = div(length(x),10), nb_pts = 30)

Performs the DCCA analysis of `x` and `y`. The default analysis starts with a window size of 3 up to one tenth of the total length of `x` for statistical reasons.

returns the dcca coefficients.
"""
function dcca(data1::Array{Float64,1},data2::Array{Float64,1};
    box_start::Int = 3, box_stop::Int = div(length(data1),10), nb_pts::Int = 30, order = 2)
    if box_start < 3
        print("ERROR : size of windows must be greater than 3")
        return
    end
    window_sizes = log_space(box_start,box_stop,nb_pts)
    rho_DCCA = zeros(length(window_sizes))
    ffi, ff1i, ff2i = 0, 0, 0
    for (index,i) in enumerate(window_sizes)
        xi = partitioning(integrate(data1),i)
        yi = partitioning(integrate(data2),i)
        n = size(xi,1)
        m = size(xi,2)
        for j in 1:n
            #testing another version of detrending
            if order == 1
                seg_x = detrending(xi[j,:])
                seg_y = detrending(yi[j,:])
            else
                seg_x = detrending_poly(xi[j,:], order)
                seg_y = detrending_poly(yi[j,:], order)
            end
            ffi += (1/n)*((1/i)*seg_x'seg_y)
            ff1i += (1/n)*((1/i)*seg_x'seg_x)
            ff2i += (1/n)*((1/i)*seg_y'seg_y)
        end
        rho_DCCA[index] = ffi/(sqrt(ff1i)*sqrt(ff2i))
    end
    return  rho_DCCA
end
