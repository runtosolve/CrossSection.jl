using CrossSection, GLMakie
## joist

t = 0.0451 #in.
L = [0.563, 1.55, 8.05, 1.55, 0.56] #in.
θ = [π/2, π, -π/2, 0.0, π/2]
r = [0.18+t, 0.18+t, 0.18+t, 0.18+t]
n = [3, 3, 3, 3, 3]
n_r = [3, 3, 3, 3]

geometry, joist = CrossSection.calculate_open_thin_walled_section_properties(L, θ, r, n, n_r, t)

#strong axis moment of inertia
joist.Ixx

function display_thin_walled_cross_section(geometry)
    f = Figure()
    ax = Axis(f[1, 1])

    lines!(ax, [geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], color=:blue, linestyle=:dash)
    lines!(ax, [geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)], [geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)], color=:gray)
    lines!(ax, [geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)], [geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)], color=:gray)
    ax.autolimitaspect = 1

    return f
end

f

f

   f
    
    display(f)

	
  


end
