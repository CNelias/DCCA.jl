 WARNING: This readme is not up to date anymore, I will update it very soon.
 ================================================================
 
 **Travis**     
:--------:
[![Build Status](https://travis-ci.com/johncwok/DCCA.jl.svg?branch=master)](https://travis-ci.com/johncwok/DCCA.jl)

Detrended Cross-Correlation Analysis
=================================================

A module to perform DCCA coefficients analysis. The coefficient rho symbolizes the strengh of the correlation between the 2 time series, it's value lies in [-1,1], a positive value indicates correlations, a negative value show anti-correlations and a value of 0 means no correlations.\
Anything in [-0.1,0.1] typically can't be considered as true correlations because of statistical fluctuations. The package therefore provides a function that returns the 95% confidence interval (estimated via bootstrap) to help analyse the results.

The implementation is based, among others, on this article:
Zebende G, Da Silva M MacHado, Filho A. *DCCA cross-correlation coefficient differentiation: Theoretical and practical approaches* Physica A: Statistical Mechanics and its Applications
(2013)

### Installation :

Copy the link provided by github above and use the clone command :
```Julia
Pkg.clone("https://github.com/johncwok/DCCA.jl.git")
```

### Perform a DCCA coefficient computation :

Call the ```rhoDCCA``` function rhoDCCA(data1,data1,box_b::Int,box_s::Int,nb_pt::Int).

Input :
* data1, data2 : the first  and second time series of data to analyse
```diff
- The input data have to be a 1D array of Float64.
```
* box_b, box_s : the starting and ending point of the analysis. It's recommended for box_s not to be to big in comparison to 
the total length of the time-series, otherwise you'll get artefacts. Stopping at a box_s roughly equal to 1/4 of the total length 
is a good idea.
* nb_pt : the number of points you want to perform the analysis onto. 

Returns :
* the list of points where the analysis was carried out
* the value of the DCCA coefficient at each of these points

### Get the 95% confidence interval

Call the ```rhoDCCA_CI``` function rhoDCCA_CI(x,y)

Input:
* x, y : The two time series to analyse.

Returns:
* lower_bound : the lower bound of the confidence interval
* upper_bound : the upper bound of the confidence interval


### Example of DCCA coefficient calculation :

calling the DCCA function with random white noise

```julia
julia> x1 = rand(1000); x2 = rand(1000)
x,y = rhoDCCA(x1,x2)
l,u = rhoDCCA_CI(x1,x2)
```
Gave the following plot :

```julia
a = plot(x,y)
plot!(a,ones(x[end]*l,label = "lower bound of CI")  
plot!(a,ones(x[end]*u,label = "upper bound of CI")  
```
<img src="https://user-images.githubusercontent.com/34754896/69163454-82224680-0aee-11ea-8437-3b56cb0770b8.JPG" width="600">
As noted previously, the value here lies in [-0.1,0.1] although we took here 2 series of white uncorrelated noise.


Requirements
------------

* Polynomials, StatsBase, Random


TO DO :
------------
- Better figure for the readme file.
