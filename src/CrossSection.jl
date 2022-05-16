module CrossSection

export Tools
include("Tools.jl")
using .Tools

function generate_thin_walled(L, θ, n)

    #anchor points
    cross_section_nodes = Tools.lay_out_cross_section_nodes(L, θ)

    #no corners in this method
    corners = []
    flats = Tools.generate_straight_line_segments(cross_section_nodes, corners, n)
    
    cross_section = Array{Vector{Float64}}(undef, 0)
    
    #round 
    for i in eachindex(flats)
    
        flats[i] = [round.(flats[i][j], digits=5) for j in eachindex(flats)]
    
    end

    #combine flats
    for i in eachindex(flats)
    
        cross_section = vcat(cross_section, flats[i])
    
    end
    
    #remove negative zeros
    for i in eachindex(cross_section)
    
        if cross_section[i][1] === -0.0
    
            cross_section[i][1] = 0.0
    
        end
    
        if cross_section[i][2] === -0.0
    
            cross_section[i][2] = 0.0
    
        end
    
    end

    #remove repeats
    cross_section = unique(cross_section)

    return cross_section

end


function generate_thin_walled(L, θ, n, r, n_r)

    cross_section_nodes = Tools.lay_out_cross_section_nodes(L, θ)

    corners = Tools.generate_cross_section_rounded_corners(cross_section_nodes, r, n_r)

    flats = Tools.generate_straight_line_segments(cross_section_nodes, corners, n)

    num_flats = size(flats)[1]
    num_corners = size(corners)[1]

    num_segments = num_flats + num_corners

    cross_section = [flats; corners]

    cross_section_index = [1:2:num_segments; 2:2:num_segments]

    cross_section_index_sorted = sortperm(cross_section_index)

    cross_section = cross_section[cross_section_index_sorted]

    cross_section = vcat(cross_section...)

    for i in eachindex(cross_section)

        cross_section[i] = round.(cross_section[i], digits=5)

        cross_section[i] = CrossSection.Tools.remove_negative_zeros(cross_section[i])

    end

    cross_section = unique(cross_section)

    return cross_section

end


# """
#     wshape_nodes(shape_info, n)

# Accepts the Struct `shape_info` generated using CrossSection.AISC and the discretization Vector `n` and outputs the outline x-y coordinates of a W shape 'xcoords' and 'ycoords'.

# The Vector 'n' describes the number of segments in a quarter cross-section, i.e., `n = [half of outside flange face, flange thickness, half of inside flange face, flange-web radius, half of web]`.

# """


# function wshape_nodes(shape_info, n)

#     #from bottom of bottom flange, web centerline to left edge
#     xcoords = zeros(n[1]+1)
#     ycoords = zeros(n[1]+1)

#     flange_range = 0.0 : -shape_info.bf / 2 / n[1] : -shape_info.bf / 2
#     [xcoords[i] =  flange_range[i] for i in eachindex(flange_range)]
#     ycoords .= 0.0

#     #up along bottom flange thickness
#     flange_thickness_range = shape_info.tf/n[2]:shape_info.tf/n[2]:shape_info.tf
#     xcoords = [xcoords; ones(n[2])*xcoords[end]]
#     ycoords = [ycoords; flange_thickness_range]

#     #over to fillet radius at bottom flange - web intersection

#     # flange_flat = shape_info.bf/2 - shape_info.k1
#     flange_flat = shape_info.bf/2 - shape_info.tw/2 - (shape_info.kdes - shape_info.tf)

#     inside_flange_range = (xcoords[end] + flange_flat/n[3]) : flange_flat/n[3] : (xcoords[end] + flange_flat)

#     xcoords = [xcoords; inside_flange_range]
#     ycoords = [ycoords; ones(n[3])*ycoords[end]]

#     #go around the fillet
#     radius = -xcoords[end] - shape_info.tw/2
#     θ = (-π/2 + π/2/n[4]):π/2/n[4]: 0.0

#     xo = xcoords[end]
#     yo = ycoords[end] + radius

#     x_radius = xo .+ radius .* cos.(θ)
#     y_radius = yo .+ radius .* sin.(θ)

#     # plot(x_radius, y_radius, markershape = :o, linetype = :scatter)

#     xcoords = [xcoords; x_radius]
#     ycoords = [ycoords; y_radius]

#     #add web flat
#     web_flat = shape_info.d/2 - shape_info.tf - radius

#     web_flat_range = LinRange(ycoords[end] + web_flat/n[5], (ycoords[end] + web_flat), n[5])
#     # web_flat_range = (ycoords[end] + web_flat/n[5]): web_flat/n[5]: (ycoords[end] + web_flat)
#     xcoords = [xcoords; ones(n[5])*xcoords[end]]
#     ycoords = [ycoords; web_flat_range]

#     #mirror about horizontal axis
#     ycoords_horz_flip = ycoords .- ycoords[end]
#     ycoords_horz_flip = -ycoords_horz_flip
#     ycoords_horz_flip = ycoords_horz_flip .+ ycoords[end]

#     xcoords = [xcoords; reverse(xcoords)[2:end]]
#     ycoords = [ycoords; reverse(ycoords_horz_flip)[2:end]]

#     #mirror about vertical axis
#     xcoords_vert_flip = reverse(-xcoords)[2:end-1]

#     xcoords = [xcoords; xcoords_vert_flip]
#     ycoords = [ycoords; reverse(ycoords)[2:end-1]]


#     return xcoords, ycoords

# end




# function discretize_w_shape_centerline_model(shape, cross_section)

#     num_branches = size(shape)[1]

#     xcoords = []
#     ycoords = []

#     for i = 1:num_branches

#         ΔL = shape[i].magnitude
#         θ = shape[i].direction
#         n = shape[i].n
#         Δxy = Geometry.vector_components(ΔL, θ) 
#         anchor = shape[i].anchor

#         if i == 1
#             xcoords = range(0.0, Δxy[1], length = n + 1) .+ anchor[1]
#             ycoords = range(0.0, Δxy[2], length = n + 1) .+ anchor[2]

#         else
#             xcoords = [xcoords; range(0.0, Δxy[1], length = n + 1) .+ anchor[1]]
#             ycoords = [ycoords; range(0.0, Δxy[2], length = n + 1) .+ anchor[2]]

#         end

#     end

#     #Round here to help unique function.
#     xycoords = [(round(xcoords[i], digits = 3), round(ycoords[i], digits = 3)) for i = 1:length(xcoords)]

#     xycoords = unique(xycoords)

#     coord = [y[i] for y in xycoords, i in 1:2]

#     #Shift coordinates so that web is centered on x=0.
#     coord[:, 1] = coord[:, 1] .- cross_section.bf/2

#     #Shift coordinates so that bottom fiber is at y=0.
#     coord[:, 2] = coord[:, 2] .+ cross_section.tf/2


#     #Define element connectivity.

#     num_elem = sum([shape[i].n for i=1:num_branches])
    
#     node_start = 1
#     node_end = shape[1].n

#     node_i = node_start:node_end
#     node_j = node_i .+ 1

#     node_start = floor(Int, shape[1].n/2)+1
#     node_end = node_end + 2

#     node_i = [node_i; node_start]
#     node_j = [node_j; node_end]

#     node_start = node_end
#     node_end = node_end + shape[2].n - 2

#     node_i = [node_i; node_start:node_end]
#     node_j = [node_j; (node_start:node_end) .+ 1]

#     node_start = shape[1].n + shape[2].n + 2
#     node_end = node_start + floor(Int, shape[2].n/2) - 1
#     node_i_range = range(node_start, node_end-1)
#     node_j_range = node_i_range .+ 1

#     node_i = [node_i; node_i_range]
#     node_j = [node_j; node_j_range]

#     node_start = node_i[end] + 1
#     node_end = shape[1].n + shape[2].n + 1

#     node_i = [node_i; node_start]
#     node_j = [node_j; node_end]

#     node_start = node_j[end]
#     node_end = node_i[end] + 1

#     node_i = [node_i; node_start]
#     node_j = [node_j; node_end]

#     node_start = shape[1].n + shape[2].n + 2 + floor(Int, shape[3].n/2)
#     node_end = node_start + floor(Int, shape[3].n/2) - 1
#     node_i_range = range(node_start, node_end-1)
#     node_j_range = node_i_range .+ 1

#     node_i = [node_i; node_i_range]
#     node_j = [node_j; node_j_range]

#     t = [ones(Float64, shape[1].n)*cross_section.tf[1]; ones(Float64, shape[2].n)*cross_section.tw[1]; ones(Float64, shape[2].n)*cross_section.tf[1]]

#     ends = [node_i node_j t]

#     return coord, ends

# end


# function define_w_shape_centerline_model(bf, tf, d, n)

#     num_branches = 3
#     w_shape = Vector{CrossSectionBranch}(undef, num_branches)

#     #first branch, bottom flange
#     anchor = (0.0, 0.0)
#     direction = 0.0
#     magnitude = bf

#     w_shape[1] = CrossSectionBranch(anchor, direction, magnitude, n[1])

#     #second branch, web
#     anchor = (bf/2, 0.0)
#     direction = 90.0
#     magnitude = d - tf

#     w_shape[2] = CrossSectionBranch(anchor, direction, magnitude, n[2])

#     #third branch, top flange
#     anchor = (0.0, d - tf)
#     direction = 0.0
#     magnitude = bf

#     w_shape[3] = CrossSectionBranch(anchor, direction, magnitude, n[3])

#     return w_shape

# end


end # module
