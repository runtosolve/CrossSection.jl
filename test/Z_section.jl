using CrossSection, GLMakie

t = 0.075
L = [1.0, 2.5, 8.0, 2.5, 1.0]
θ = [deg2rad(-55.0), 0.0, π/2, 0.0, deg2rad(-55.0)]
r = [3*t, 3*t, 3*t, 3*t]
n = [3, 3, 3, 3, 3]
n_r = [3, 3, 3, 3]

geometry, section_properties = Shapes.Z_section(L, θ, r, n, n_r, t)

plot_open_thin_walled_cross_section(geometry)

# y_top = [geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)]
# y_bottom = [geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)]

# minimum(y_bottom) - maximum(y_top) 



function plot_open_thin_walled_cross_section(geometry)
	f = Figure()
	    ax = GLMakie.Axis(f[1, 1])
	
	    lines!(ax, [geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], color=:blue, linestyle=:dash)
	    lines!(ax, [geometry.top[i][1] for i in eachindex(geometry.top)], [geometry.top[i][2] for i in eachindex(geometry.top)], color=:gray)
	    lines!(ax, [geometry.bottom[i][1] for i in eachindex(geometry.bottom)], [geometry.bottom[i][2] for i in eachindex(geometry.bottom)], color=:gray)
	    ax.autolimitaspect = 1
	f
end
