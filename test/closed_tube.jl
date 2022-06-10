using CrossSection

L = [5.0, 5.0, 5.0, 5.0]
θ = [0.0, π/2, π, 3π/2]
n = [3, 3, 3, 3]
r = [0.09, 0.09, 0.09, 0.09]
n_r = [3, 3, 3, 3]


#two methods

#with corner radii
cross_section = CrossSection.generate_thin_walled(L, θ, n, r, n_r)


#straight corner
cross_section = CrossSection.generate_thin_walled(L, θ, n)


X = [cross_section[i][1] for i in eachindex(cross_section)]
Y = [cross_section[i][2] for i in eachindex(cross_section)]

using Plots
plot(X, Y, markershape = :o, aspect_ratio = :equal, seriestype = :scatter)

unit_node_normals = CrossSection.Tools.calculate_cross_section_unit_node_normals(cross_section)

out = cross_section[1:end-1] #trim last [0.0, 0.0] node for closed cross-section

t = 0.2
Δ = -t/2
centerline = CrossSection.Tools.get_coords_along_node_normals(out, unit_node_normals[1:end-1], Δ)

X = [centerline[i][1] for i in eachindex(centerline)]
Y = [centerline[i][2] for i in eachindex(centerline)]
plot!(X, Y, markershape = :o, aspect_ratio = :equal, seriestype = :scatter)


