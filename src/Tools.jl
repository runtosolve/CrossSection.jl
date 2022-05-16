module Tools

using LinesCurvesNodes, LinearAlgebra, StaticArrays, LazySets


function lay_out_cross_section_nodes(L, θ)

    num_segments = length(L)

    cross_section = Array{Vector{Float64}}(undef, num_segments)

    for i in eachindex(L)

        if i == 1

            start_node = [0.0, 0.0]

        else

            start_node = cross_section[i-1]

        end

        cross_section[i] = round.(LinesCurvesNodes.transform_vector(L[i], start_node, θ[i]), digits=5)

        cross_section[i] = remove_negative_zeros(cross_section[i])

    end

    cross_section = [[[0.0, 0.0]]; cross_section] #add start node at unity

    return cross_section

end



function generate_cross_section_rounded_corners(cross_section_nodes, r, n)

    corners = Array{Array{Vector{Float64}}}(undef, length(r))

    for i in eachindex(r)

        if (i == length(r)) & (cross_section_nodes[1] == cross_section_nodes[end]) #closed section

            A = cross_section_nodes[end-1] 
            B = cross_section_nodes[1]
            C = cross_section_nodes[2]

        else #open section 

            A = cross_section_nodes[i] 
            B = cross_section_nodes[i+1]
            C = cross_section_nodes[i+2]

        end
        
        corners[i] = LinesCurvesNodes.generate_fillet(A, B, C, r[i], n[i])

    end

   return corners

end



function generate_straight_line_segments(cross_section_nodes, corners, n)

    segments = Array{Vector{Vector{Float64}}}(undef, length(n))

    if corners == []

        for i in eachindex(n)

            A = cross_section_nodes[i]
            B = cross_section_nodes[i+1]

            segments[i] = LinesCurvesNodes.discretize_vector(A, B, n[i])

        end

    else 

        if cross_section_nodes[1] != cross_section_nodes[end]  #open cross-sections 

            corner_index = 1

            for i in eachindex(n)

                if i == 1

                    A = cross_section_nodes[1]
                    B = corners[1][1]


                elseif i == length(n)

                    A = corners[corner_index][end]
                    B = cross_section_nodes[end]

                else
                    A = corners[corner_index][end]
                    corner_index += 1
                    B = corners[corner_index][1]

                end

                segments[i] = LinesCurvesNodes.discretize_vector(A, B, n[i])

            end

        else  #closed cross-sections

            corner_index = 1

            for i in eachindex(n)

                if i == 1

                    A = corners[end][end]
                    B = corners[1][1]


                elseif i == length(n)

                    A = corners[corner_index][end]
                    B = corners[end][1]

                else
                    A = corners[corner_index][end]
                    corner_index += 1
                    B = corners[corner_index][1]

                end

                segments[i] = LinesCurvesNodes.discretize_vector(A, B, n[i])

            end   
            
        end

    end

    return segments

end


function calculate_node_normal(A, B, C)

    BC = C-B
    BA = A-B

    BR = BA + BC/norm(BC) * norm(BA)

    return BR

end


function calculate_cross_section_unit_node_normals(cross_section)

    num_nodes = size(cross_section)[1]
    unit_node_normals = Array{Vector{Float64}}(undef, num_nodes)

    for i=1:num_nodes

        if i == 1

            if cross_section[end] == cross_section[1]  #closed cross-sections

                A = cross_section[end-1]
                B = cross_section[1]
                C = cross_section[2]

                node_normal = calculate_node_normal(A, B, C)

                if isapprox(abs.(node_normal), [0.0, 0.0], atol=1e-8)
        
                    BA = A-B
                    unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

                    unit_node_normals[i] = right_halfspace_normal_correction(A, B, unit_node_normals[i]) 

                else

                    unit_node_normals[i] = -node_normal / norm(node_normal)

                    unit_node_normals[i] = right_halfspace_normal_correction(A, B, unit_node_normals[i]) 

                end

            else  #open cross-sections 

                A = cross_section[1]
                B = cross_section[2]

                BA = A-B

                unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

                unit_node_normals[i] = right_halfspace_normal_correction(A, B, unit_node_normals[i]) 

            end

        elseif i == num_nodes

            A = cross_section[end-1]
            B = cross_section[end]

            BA = A-B

            unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

            unit_node_normals[i] = right_halfspace_normal_correction(A, B, unit_node_normals[i]) 

        else

            A = cross_section[i-1]
            B = cross_section[i]
            C = cross_section[i+1]

            node_normal = calculate_node_normal(A, B, C)

            if isapprox(abs.(node_normal), [0.0, 0.0], atol=1e-8)
    
                BA = A-B
                unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

                unit_node_normals[i] = right_halfspace_normal_correction(A, B, unit_node_normals[i]) 

            else

                unit_node_normals[i] = -node_normal / norm(node_normal)

                unit_node_normals[i] = right_halfspace_normal_correction(A, B, unit_node_normals[i]) 

            end

        end


        unit_node_normals[i] = remove_negative_zeros(unit_node_normals[i])

    end

    return unit_node_normals

end


function get_coords_along_node_normals(cross_section, unit_node_normals, Δ)

    normal_cross_section = Array{Vector{Float64}}(undef, 0)

    for i in eachindex(cross_section)

        push!(normal_cross_section, cross_section[i] + unit_node_normals[i] * Δ)

    end

    return normal_cross_section

end


function right_halfspace_normal_correction(A, B, normal) 

    s = LineSegment(A, B)
    hs = halfspace_right(s) #for counterclockwise node layout, right is outside
    dA = A + 1.0 * normal
    if !∈(dA, hs)  #is the node normal pointing outside or inside, if it is pointing inside, reverse sign to make it point outside
        normal = -normal
    end

    return normal

end


function remove_negative_zeros(coord)

    if coord[1] === -0.0

        coord[1] = 0.0

    end

    if coord[2] === -0.0

        coord[2] = 0.0

    end

    return coord

end

end #module