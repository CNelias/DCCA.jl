 **Travis**     
:--------:
[![Build Status](https://travis-ci.com/johncwok/DCCA.jl.svg?branch=master)](https://travis-ci.com/johncwok/DCCA.jl)

Detrended Cross-Correlation Analysis
=================================================

A module to perform DCCA coefficients analysis. The coefficient rho symbolizes the strengh of the correlation between the 2 time series, it's value lies in [-1,1], a positive value indicates correlations, a negative value show anti-correlations and a value of 0 means no correlations.
Anything in [-0.1,0.1] can in practice be considered as showing no correlations because of statistical artifacts. Indeed running the method with white noise typically gives out a curve in this range.

The implementation is based, among others, on this article:
Zebende G, Da Silva M MacHado, Filho A. *DCCA cross-correlation coefficient differentiation: Theoretical and practical approaches* Physica A: Statistical Mechanics and its Applications
(2013)

### Installation :

Copy the link provided by github above and use the clone command :
```Julia
Pkg.clone("https://github.com/johncwok/DCCA.jl.git")
```

### Perform a DCCA coefficient computation :

Call the rhoDCCA function rhoDCCA(data1,data1,box_b::Int,box_s::Int,nb_pt::Int).

the arguments have the following meaning :
* data1, data2 : the first  and second time series of data to analyse
```diff
- The input data have to be a 1D array.
```
* box_b, box_s : the starting and ending point of the analysis. It's recommended for box_s not to be to big in comparison to 
the total length of the time-series, otherwise you'll get artefacts. Stopping at a box_s roughly equal to 1/4 of the total length 
is a good idea.
* nb_pt : the number of points you want to perform the analysis onto. 

the function returns :
* the list of points where the analysis was carried out
* the value of the DCCA coefficient at each of these points


### Example of DCCA coefficient calculation :

calling the DCCA function with random white noise

```julia
julia> x1 = rand(1000); x2 = rand(1000)
x,y = rhoDCCA(x,x,20,200,30)
```
Gave the following plot :

```julia
plot(x,y,"bo-",markersize = 4, label = "strengh of correlation")
title("DCCA coefficients analysis of data")
legend()
xlabel("Window size s")
xscale("log")
ylabel(L"$\rho_{DCCA}(s)$")
```

![index](https://user-images.githubusercontent.com/34754896/42820668-f9ff05ca-89d6-11e8-9208-73d33aa3c137.png)

As noted previously, the value here lies in [-0.1,0.1] although we took here 2 series of white uncorrelated noise. It is therefore important to ask yourself if your result is statistacally relevant. Here is a visual representation to show what I mean.

The confidence interval was estimated by simulation and is therefore not an analytical result : even if you find a value of 0.3, you should do the experiment again to be sure that you actually found correlation and not statistical fluctuations. 

![DCCA_significance_test](https://user-images.githubusercontent.com/34754896/59430685-3783fc00-8de3-11e9-9390-b688df35e5fe.PNG)


Requirements
------------

* Polynomials


TO DO :
------------
- Tidy up the code, optimize it and rename the variables.

