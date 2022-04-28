module CrossSection

export Tools
include("Tools.jl")
using .Tools

function generate_open(L, θ, r, n, n_radius)

    cross_section_nodes = Tools.lay_out_cross_section_nodes(L, θ)

    corners = Tools.generate_cross_section_rounded_corners(cross_section_nodes, r, n_radius)

    flats = Tools.generate_straight_line_segments(cross_section_nodes, corners, n)

    num_flats = size(flats)[1]
    num_corners = size(corners)[1]

    num_segments = num_flats + num_corners

    cross_section = [flats; corners]

    cross_section_index = [1:2:num_segments; 2:2:num_segments]

    cross_section_index_sorted = sortperm(cross_section_index)

    cross_section = cross_section[cross_section_index_sorted]

    cross_section = vcat(cross_section...)

    cross_section = round(cross_section, sigdigits=5)   #round to help unique function work

    cross_section = unique(cross_section, dims=1)

    return cross_section

end

end # module
