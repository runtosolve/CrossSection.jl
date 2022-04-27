module Tools

using LinesCurvesNodes, LinearAlgebra, StaticArrays


function lay_out_cross_section_nodes(L, θ)

    num_segments = length(L)

    cross_section = Array{SVector{2, Float64}}(undef, num_segments)

    for i in eachindex(L)

        if i == 1

            start_node = [0.0, 0.0]

        else

            start_node = cross_section[i-1]

        end

        cross_section[i] = LinesCurvesNodes.transform_vector(L[i], start_node, θ[i])

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
    
        corners[i] = LinesCurvesNodes.generate_fillet(A, B, C, r[i], n[i])

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

        segments[i] = LinesCurvesNodes.discretize_vector(A, B, n[i])

    end

    return segments

end




# # calculate surface normals for each line segment in a 2D cross-section
# function calculate_element_surface_normals(xcoords, ycoords, section_type)
   
#     if section_type == "closed"
#         numel = length(xcoords)   #closed
#     elseif section_type == "open"
#         numel = length(xcoords) - 1  #open
#     end

#     unit_element_normals = zeros(Float64, (numel, 2))

#     for i=1:numel

#         if (i == numel) & (section_type == "closed")   #for tubes
#             A = [xcoords[i], ycoords[i]]
#             B = [xcoords[1], ycoords[1]]
#         else
#             A = [xcoords[i], ycoords[i]]
#             B = [xcoords[i + 1], ycoords[i + 1]]
#         end

#         AB = B - A

#         normAB = norm(AB)

#         unit_element_normals[i, :] = [-AB[2], AB[1]] / normAB

#         if unit_element_normals[i,1] == -0.0
#             unit_element_normals[i,1]= 0.0
#         end

#         if unit_element_normals[i,2] == -0.0
#             unit_element_normals[i,2]= 0.0
#         end

#     end

#     return unit_element_normals

# end


# calculate average unit normals at each node in a 2D cross-section from element unit normals
# function calculate_node_normals(unit_element_normals, section_type)

#     if section_type == "closed"
#         numnodes = size(unit_element_normals)[1]
#         numel = size(unit_element_normals)[1]
#     elseif section_type == "open"
#         numnodes = size(unit_element_normals)[1] + 1
#         numel = size(unit_element_normals)[1]
#     end

#     node_normals = zeros(Float64, (numnodes, 2))

#     for i=1:numnodes

#         if (i == 1) & (section_type == "closed")  # where nodes meet in the tube
#             node_normals[i, :] = mean(unit_element_normals[[numel, 1], :], dims=1)
#         elseif (i != 1) & (section_type == "closed")  #tube
#             node_normals[i, :] = mean(unit_element_normals[i-1:i, :], dims=1)
#         elseif (i == 1) & (section_type == "open")  #open, first node is element norm
#             node_normals[i, :] = unit_element_normals[i, :]
#         elseif (i != 1) & (i != numnodes) & (section_type == "open")  #open
#             node_normals[i, :] = mean(unit_element_normals[i-1:i, :], dims=1)
#         elseif (i == numnodes) & (section_type == "open")  #open, last node is element norm
#             node_normals[i, :] = unit_element_normals[i-1, :]

#         end

#         #make sure unit normal always = 1.0
#         unitnorm = norm(node_normals[i, :])
#         if unitnorm < 0.99
#             scale = 1.0/unitnorm
#             node_normals[i,:] = scale .* node_normals[i,:]
#         end

#     end

#     return nodenormals

# end



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

            A = [cross_section[1, 1], cross_section[1, 2]]
            B = [cross_section[2, 1], cross_section[2, 2]]

            BA = A-B

            unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

        elseif i == num_nodes

            A = [cross_section[end-1, 1], cross_section[end-1, 2]]
            B = [cross_section[end, 1], cross_section[end, 2]]

            BA = A-B

            unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

        else

            A = [cross_section[i-1, 1], cross_section[i-1, 2]]
            B = [cross_section[i, 1], cross_section[i, 2]]
            C = [cross_section[i+1, 1], cross_section[i+1, 2]]

            node_normal = calculate_node_normal(A, B, C)

            if isapprox(abs.(node_normal), [0.0, 0.0], atol=1e-8)
    
                BA = A-B
                unit_node_normals[i] = [-BA[2], BA[1]] / norm(BA)

            else

                unit_node_normals[i] = -node_normal / norm(node_normal)

            end

        end

        if unit_node_normals[i][1] == -0.0
            unit_node_normals[i][1]= 0.0
        end

        if unit_node_normals[i][2] == -0.0
            unit_node_normals[i][2]= 0.0
        end

    end

    return unit_node_normals

end


function xycoords_along_normal(xcoords, ycoords, nodenormals, Δ)

    numnodes = size(xcoords)[1]
    xcoords_normal = []
    ycoords_normal = []

    for i=1:numnodes

        if i == 1

            xcoords_normal = xcoords[i] + nodenormals[i, 1] * Δ
            ycoords_normal = ycoords[i] + nodenormals[i, 2] * Δ

        else

            xcoords_normal = [xcoords_normal; (xcoords[i] + nodenormals[i, 1] * Δ)]
            ycoords_normal = [ycoords_normal; (ycoords[i] + nodenormals[i, 2] * Δ)]

        end

    end

    return xcoords_normal, ycoords_normal

end

end #module