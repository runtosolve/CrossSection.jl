module Show

using CairoMakie

function open_thin_walled_section(geometry, t, drawing_scale, linecolor, markersize)

    x = [geometry.center[i][1] for i in eachindex(geometry.center)]
    y = [geometry.center[i][2] for i in eachindex(geometry.center)]

    Δx = abs(maximum(x) - minimum(x))
    Δy = abs(maximum(y) - minimum(y))

    # figure = Figure(resolution = (Δx*72 * drawing_scale * (Δx/Δy), Δy*72 * drawing_scale))
    figure = Figure(resolution = (Δx*72, Δy*72) .* drawing_scale)
    ax = Axis(figure[1, 1], aspect = Δx/Δy)
    thickness_scale = maximum(t) * 72 * drawing_scale
    num_elem = length(x)-1
    # linewidths = fill(t, num_elem) ./ maximum(fill(t, num_elem)) * thickness_scale
	linewidths = t ./ maximum(t) * thickness_scale
    [scatterlines!(x[i:i+1], y[i:i+1], linewidth=linewidths[i], color=linecolor, markersize=markersize) for i=1:num_elem];

    return ax, figure

end


function open_thin_walled_section(x, y, t, drawing_scale, linecolor, markersize)

    # x = [geometry.center[i][1] for i in eachindex(geometry.center)]
    # y = [geometry.center[i][2] for i in eachindex(geometry.center)]

    Δx = abs(maximum(x) - minimum(x))
    Δy = abs(maximum(y) - minimum(y))

    # figure = Figure(resolution = (Δx*72 * drawing_scale * (Δx/Δy), Δy*72 * drawing_scale))
    figure = Figure(resolution = (Δx*72, Δy*72) .* drawing_scale)
    ax = Axis(figure[1, 1], aspect = Δx/Δy)
    thickness_scale = maximum(t) * 72 * drawing_scale
    num_elem = length(x)-1
    # linewidths = fill(t, num_elem) ./ maximum(fill(t, num_elem)) * thickness_scale
	linewidths = t ./ maximum(t) * thickness_scale
    [scatterlines!(x[i:i+1], y[i:i+1], linewidth=linewidths[i], color=linecolor, markersize=markersize) for i=1:num_elem];

    return ax, figure

end



function closed_thin_walled_section(geometry, t, drawing_scale, linecolor, markersize)

    x = [geometry.center[i][1] for i in eachindex(geometry.center)]
    y = [geometry.center[i][2] for i in eachindex(geometry.center)]

	x = [x; x[1]]
	y = [y; y[1]]

    Δx = abs(maximum(x) - minimum(x))
    Δy = abs(maximum(y) - minimum(y))

    figure = Figure(resolution = (Δx*72, Δy*72) .* drawing_scale)
    ax = Axis(figure[1, 1])
    thickness_scale = maximum(t) * 72 * drawing_scale
    num_elem = length(x)-1
    linewidths = t ./ maximum(t) * thickness_scale
    [scatterlines!(x[i:i+1], y[i:i+1], linewidth=linewidths[i], color=linecolor, markersize=markersize) for i=1:num_elem];

    return ax, figure

end

function closed_thin_walled_section(x, y, t, drawing_scale, linecolor, markersize)

    # x = [geometry.center[i][1] for i in eachindex(geometry.center)]
    # y = [geometry.center[i][2] for i in eachindex(geometry.center)]

	# x = [x; x[1]]
	# y = [y; y[1]]

    Δx = abs(maximum(x) - minimum(x))
    Δy = abs(maximum(y) - minimum(y))

    figure = Figure(resolution = (Δx*72, Δy*72) .* drawing_scale)
    ax = Axis(figure[1, 1])
    thickness_scale = maximum(t) * 72 * drawing_scale
    num_elem = length(x)-1
    linewidths = t ./ maximum(t) * thickness_scale
    [scatterlines!(x[i:i+1], y[i:i+1], linewidth=linewidths[i], color=linecolor, markersize=markersize) for i=1:num_elem];

    return ax, figure

end





# function plot_thin_walled_cross_section(geometry)

# 	plot([geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], linestyle=:dash, linecolor=:blue, aspect_ratio=:equal, legend=false)

# 	plot!([geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)], [geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)], linecolor=:gray, aspect_ratio=:equal)

# 	plot!([geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)], [geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)], linecolor=:gray, aspect_ratio=:equal)

# end

# function plot_closed_thin_walled_cross_section(geometry)
# 	f = Figure()
# 	    ax = GLMakie.Axis(f[1, 1])
	
# 	    lines!(ax, [[geometry.centerline[i][1] for i in eachindex(geometry.centerline)]; geometry.centerline[1][1]], [[geometry.centerline[i][2] for i in eachindex(geometry.centerline)]; geometry.centerline[1][2]], color=:blue, linestyle=:dash)
# 	    lines!(ax, [[geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)]; geometry.outside_face[1][1]], [[geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)]; geometry.outside_face[1][2]], color=:gray)
# 	    lines!(ax, [[geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)]; geometry.inside_face[1][1]], [[geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)]; geometry.inside_face[1][2]], color=:gray)
# 	    ax.autolimitaspect = 1
# 	f
# end

# function plot_open_thin_walled_cross_section(geometry)
# 	f = Figure()
# 	    ax = GLMakie.Axis(f[1, 1])
	
# 	    lines!(ax, [geometry.centerline[i][1] for i in eachindex(geometry.centerline)], [geometry.centerline[i][2] for i in eachindex(geometry.centerline)], color=:blue, linestyle=:dash)
# 	    lines!(ax, [geometry.outside_face[i][1] for i in eachindex(geometry.outside_face)], [geometry.outside_face[i][2] for i in eachindex(geometry.outside_face)], color=:gray)
# 	    lines!(ax, [geometry.inside_face[i][1] for i in eachindex(geometry.inside_face)], [geometry.inside_face[i][2] for i in eachindex(geometry.inside_face)], color=:gray)
# 	    ax.autolimitaspect = 1
# 	f
# end


end #module 