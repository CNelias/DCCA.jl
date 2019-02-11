using Test
using DCCA

x1 = rand(1000); x2 = rand(1000)
@test x,y = rhoDCCA(x1,x2,20,200,30)
