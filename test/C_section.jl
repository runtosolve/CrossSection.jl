using CrossSection, GLMakie
## joist

function plot_open_thin_walled_cross_section(geometry)
	f = Figure()
	    ax = GLMakie.Axis(f[1, 1])
	
	    lines!(ax, [geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], color=:blue, linestyle=:dash)
	    lines!(ax, [geometry.top[i][1] for i in eachindex(geometry.top)], [geometry.top[i][2] for i in eachindex(geometry.top)], color=:gray)
	    lines!(ax, [geometry.bottom[i][1] for i in eachindex(geometry.bottom)], [geometry.bottom[i][2] for i in eachindex(geometry.bottom)], color=:gray)
	    ax.autolimitaspect = 1
	f
end


t = 0.0451 #in.
L = [0.563, 1.55, 8.05, 1.55, 0.56] #in.
θ = reverse([π/2, π, -π/2, 0.0, π/2])
r = [0.18+t, 0.18+t, 0.18+t, 0.18+t]
n = [3, 3, 3, 3, 3]
n_r = [3, 3, 3, 3]

geometry, joist = Properties.open_thin_walled(L, θ, r, n, n_r, t, centerline="to left")

plot_open_thin_walled_cross_section(geometry)





