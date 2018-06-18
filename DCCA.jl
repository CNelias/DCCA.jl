using PyPlot 
using Polynomials

# attention à la fonction reshape(), elle remplie en premier la dimension i (de (i,j)), sans considerations logiques

function partitioning(x,box_size;backward = false) 
    if backward == false
        data_forward = copy(x)
        for i in 1:length(x) 
            if length(data_forward) % box_size != 0
                deleteat!(data_forward,length(data_forward))
            elseif isa(length(data_forward)/box_size,Int)
                break
            end
        end
        processed_data = copy(data_forward)
        return reshape(processed_data,(box_size,Int(length(processed_data)/box_size)))  
    elseif backward == true
        data_forward = copy(x)
        data_backward = copy(x)
            for i in 1:length(x) 
                if length(data_forward) % box_size != 0
                    deleteat!(data_forward,length(data_forward))
                elseif isa(length(data_forward)/box_size,Int)
                    break
                end
            end
        for i in 1:length(x)
            if length(data_backward) % box_size != 0
                deleteat!(data_backward,1)
            elseif isa(length(data_backward)/box_size,Int)
                break
            end
        end  
        processed_data = vcat(data_forward,data_backward)
        return reshape(processed_data,(Int(length(processed_data)/box_size),box_size))  
    end
end

function detrending(values; reg_type = "linear", order = 3)
    position = collect(1:length(values))
    if reg_type == "polynomial"
    fit = polyfit(position,values,order)
    return values -  polyval(fit,position)
    elseif reg_type == "linear"
    curve = linreg(position,values)
    return values - (position*curve[2] + curve[1])
    end
end

function integrate(x)
    integrated_x = Float64[]
    sumx = 0
    for i in x
        sumx += i
        append!(integrated_x,sumx)
    end
    return integrated_x 
end

function fluctuation_function(x,y; fit_type = "linear", box_start = 5, box_stop = 80, backwards = false)
    ff = Float64[]
    for i in  box_start:box_stop
        ffi = 0
        xi = partitioning(integrate(x),i)#; backward = backwards)
        yi = partitioning(integrate(y),i)#; backward = backwards)
        for j in 1:length(xi[1,:])
            ffi += (1/length(xi[1,:]))*((1/i)*detrending(xi[:,j]; reg_type = fit_type)'detrending(yi[:,j]; reg_type = fit_type))
        end
        append!(ff,sqrt(abs(ffi)))
    end
    return ff
end
