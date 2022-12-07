module Viz 

using GLMakie


# function plot_thin_walled_cross_section(geometry)

# 	plot([geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], linestyle=:dash, linecolor=:blue, aspect_ratio=:equal, legend=false)

# 	plot!([geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)], [geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)], linecolor=:gray, aspect_ratio=:equal)

# 	plot!([geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)], [geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)], linecolor=:gray, aspect_ratio=:equal)

# end

function plot_closed_thin_walled_cross_section(geometry)
	f = Figure()
	    ax = GLMakie.Axis(f[1, 1])
	
	    lines!(ax, [[geometry.centerline[i][1] for i in eachindex(geometry.centerline)]; geometry.centerline[1][1]], [[geometry.centerline[i][2] for i in eachindex(geometry.centerline)]; geometry.centerline[1][2]], color=:blue, linestyle=:dash)
	    lines!(ax, [[geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)]; geometry.outside_face[1][1]], [[geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)]; geometry.outside_face[1][2]], color=:gray)
	    lines!(ax, [[geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)]; geometry.inside_face[1][1]], [[geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)]; geometry.inside_face[1][2]], color=:gray)
	    ax.autolimitaspect = 1
	f
end

function plot_open_thin_walled_cross_section(geometry)
	f = Figure()
	    ax = GLMakie.Axis(f[1, 1])
	
	    lines!(ax, [geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], color=:blue, linestyle=:dash)
	    lines!(ax, [geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)], [geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)], color=:gray)
	    lines!(ax, [geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)], [geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)], color=:gray)
	    ax.autolimitaspect = 1
	f
end


end