using CrossSection


L = [0.75, 2.0, 4.0, 0.75]
θ = [π/2, π, 3π/2, 0.0]

n_r = [3, 3, 3]
n = [4, 4, 4, 4]
r = 0.09 * ones(Float64, 3)

cross_section = CrossSection.generate_thin_walled(L, θ, n, r, n_r)

X = [cross_section[i][1] for i in eachindex(cross_section)]
Y = [cross_section[i][2] for i in eachindex(cross_section)]

plot(X, Y, markershape = :o, aspect_ratio = :equal)






using Plots
plot(cross_section[:,1], cross_section[:, 2], markershape = :o, legend=false, aspect_ratio=:equal)


using LinearAlgebra






unit_node_normals = calculate_cross_section_unit_node_normals(cross_section)


node = 9

A = [cross_section[node-1, 1], cross_section[node-1,2]]
B = [cross_section[node, 1], cross_section[node,2]]
C = [cross_section[node+1, 1], cross_section[node+1,2]]

node_normal = calculate_node_normal(A, B, C)

unit_node_normals[1]