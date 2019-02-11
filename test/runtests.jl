using Test
using DCCA

x1 = rand(1000); x2 = rand(1000)
@test x,y = rhoDCCA(x,x,20,200,30)
