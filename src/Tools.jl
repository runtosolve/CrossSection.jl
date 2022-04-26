module Tools

using LinesCurves, LinearAlgebra, StaticArrays


function lay_out_cross_section_nodes(L, θ)

    num_segments = length(L)

    cross_section = Array{SVector{2, Float64}}(undef, num_segments)

    for i in eachindex(L)

        if i == 1

            start_node = [0.0, 0.0]

        else

            start_node = cross_section[i-1]

        end

        cross_section[i] = LinesCurves.transform_vector(L[i], start_node, θ[i])

    end

    cross_section = [[[0.0 0.0]]; cross_section] #add start node at unity

    return cross_section

end



function generate_cross_section_rounded_corners(cross_section_nodes, r, n)

    corners = Array{Matrix{Float64}}(undef, length(r))

   for i in eachindex(r)

        A = vec(cross_section_nodes[i]) #need vector format here for fillet calculations
        B = vec(cross_section_nodes[i+1])
        C = vec(cross_section_nodes[i+2])
    
        corners[i] = LinesCurves.generate_fillet(A, B, C, r[i], n[i])

   end

   return corners

end



function generate_straight_line_segments(cross_section_nodes, corners, n)

    segments = Array{Matrix{Float64}}(undef, length(n))

    corner_index = 1

    for i in eachindex(n)

        if i == 1

            A = vec(cross_section_nodes[1])
            B = corners[1][1,:]


        elseif i == length(n)

            A = corners[corner_index][end, :]
            B = vec(cross_section_nodes[end])

        else
            A = corners[corner_index][end, :]
            corner_index += 1
            B = corners[corner_index][1, :]

        end

        segments[i] = LinesCurves.discretize_vector(A, B, n[i])

    end

    return segments

end

end #module