using CrossSection


L = [0.75, 2.0, 4.0, 0.75]
θ = [π/2, π, 3π/2, 0.0]


# L = [0.75, 4.0, 2.0, 0.75]
# θ = [π, π/2, 0.0, -π/2]

n_radius = [3, 3, 3]
n = [4, 4, 4, 4]
r = 0.09 * ones(Float64, 3)

cross_section = CrossSection.generate_open(L, θ, r, n, n_radius)


cross_section_nodes = Tools.lay_out_cross_section_nodes(L, θ)

using Plots
plot()
[plot!([cross_section_nodes[i][1]], [cross_section_nodes[i][2]], markershape = :o, legend = false, aspect_ratio=:equal) for i in eachindex(cross_section_nodes)]
current()
    

corners = Tools.generate_cross_section_rounded_corners(cross_section_nodes, r, n_radius)

plot!(corners[1][:,1], corners[1][:,2], markershape = :o)
plot!(corners[2][:,1], corners[2][:,2], markershape = :o)
plot!(corners[3][:,1], corners[3][:,2], markershape = :o)


    flats = Tools.generate_straight_line_segments(cross_section_nodes, corners, n)

    num_flats = size(flats)[1]
    num_corners = size(corners)[1]

    num_segments = num_flats + num_corners

    cross_section = [flats; corners]

    cross_section_index = [1:2:num_segments; 2:2:num_segments]

    cross_section_index_sorted = sortperm(cross_section_index)

    cross_section = cross_section[cross_section_index_sorted]

    cross_section = vcat(cross_section...)

    cross_section = unique(cross_section, dims=1)




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