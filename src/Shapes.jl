module Shapes 

using ..Properties

function Z_section(L, θ, r, n, n_r, t)

    #start cross section definition at bottom lip 
    #define Z dimensions based on surface projections, not out to out 
    #calculate the correction on out-to-out length to go from the outside surface to the inside bottom flange surface.
    Δ_lip_bottom = t / tan((π - abs(θ[1])) / 2)

    L[1] = L[1] - Δ_lip_bottom  #shorten bottom lip to inside surface
    L[2] = L[2] - Δ_lip_bottom - t #shorten bottom flange to inside surface
    L[3] = L[3] - t #short web 

    r[1] = r[1] - t
    r[2] = r[2] - t

    section_geometry, section_properties = Properties.open_thin_walled(L, θ, r, n, n_r, t)

    return section_geometry, section_properties

end

function define_fluted_deck_cross_section(edge_width, flute_width, flute_web_length, flute_space, flute_web_angle, num_flutes)

    unit_flute_L = [flute_web_length, flute_width, flute_web_length]

    unit_flute_θ = [-flute_web_angle, 0.0, flute_web_angle]

    L = []
    θ = []
    for i = 1:num_flutes

        if i == 1

            L = vcat(edge_width, unit_flute_L)
            θ = vcat(0.0, unit_flute_θ)

        elseif i == num_flutes

            L = vcat(L, flute_space, unit_flute_L, edge_width)
            θ = vcat(θ, 0.0, unit_flute_θ, 0.0)

        else
            L = vcat(L, flute_space, unit_flute_L)
            θ = vcat(θ, 0.0, unit_flute_θ)

        end

    end

    return L, θ

end


end #module


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