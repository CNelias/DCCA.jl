using Test
using DCCA

x1 = rand(1000); x2 = rand(1000)
print(rhoDCCA(x1,x2)
@test rhoDCCA(x1,x2) == rhoDCCA(x1,x2)
