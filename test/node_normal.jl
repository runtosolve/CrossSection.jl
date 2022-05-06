using CrossSection


d = 1.0
b = 3.5
h = 10.0
r_inside = 0.1863
t = 0.1242 


L = [d, b, h, b, d]
θ = [π/2, π, 3π/2, 0.0, π/2]
n = [4, 4, 4, 4, 4]
n_radius = [3, 3, 3, 3]
r = r_inside * ones(Float64, length(n_radius))  .+ t  #outside 

cross_section = CrossSection.generate_open(L, θ, r, n, n_radius)

using Plots
plot(cross_section[:, 1], cross_section[:, 2], markershape = :o, aspect_ratio=:equal)

unit_node_normals = CrossSection.Tools.calculate_cross_section_unit_node_normals(cross_section)
x_center, y_center = CrossSection.Tools.get_coords_along_node_normals(cross_section[:,1], cross_section[:, 2], unit_node_normals, -t/2)

plot!(x_center, y_center, markershape = :o, aspect_ratio=:equal)





using LazySets

A = [cross_section[1,1], cross_section[1,2]]
B = [cross_section[2,1], cross_section[2,2]]
normal = unit_node_normals[1]

function right_halfspace_normal_correction(A, B, normal) 

    s = LineSegment(A, B)
    hs = halfspace_right(s) #for counterclockwise node layout, right is outside
    dA = A + 1.0 * normal
    if !∈(dA, hs)  #is the node normal pointing outside or inside, if it is pointing inside, reverse sign to make it point outside
        normal = -normal
    end

    return normal

end
    






