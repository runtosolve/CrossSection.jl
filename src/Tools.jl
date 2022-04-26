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




# calculate surface normals for each line segment in a 2D cross-section
function surface_normals(xcoords, ycoords, closed_or_open)


    if closed_or_open == 0
        numel = length(xcoords)   #closed
    elseif closed_or_open ==1
        numel = length(xcoords) - 1  #open
    end

    unitnormals = zeros(Float64, (numel, 2))

    for i=1:numel

        if (i == numel) & (closed_or_open == 0)   #for tubes
            pointA = Point(xcoords[i], ycoords[i])
            pointB = Point(xcoords[1], ycoords[1])
        else
            pointA = Point(xcoords[i], ycoords[i])
            pointB = Point(xcoords[i + 1], ycoords[i + 1])
        end

        dx = pointB.x - pointA.x
        dy = pointB.y - pointA.y

        normAB = norm([dx, dy])

        unitnormals[i, :] = [-dy, dx] / normAB

        if unitnormals[i,1] == -0.0
            unitnormals[i,1]= 0.0
        end

        if unitnormals[i,2] == -0.0
            unitnormals[i,2]= 0.0
        end

    end

    return unitnormals

end


# calculate average unit normals at each node in a 2D cross-section from element unit normals
function avg_node_normals(unitnormals, closed_or_open)

    if closed_or_open == 0
        numnodes = size(unitnormals)[1]
        numel = size(unitnormals)[1]
    elseif closed_or_open ==1
        numnodes = size(unitnormals)[1]+1
        numel = size(unitnormals)[1]
    end

    nodenormals = zeros(Float64, (numnodes, 2))

    for i=1:numnodes

        if (i == 1) & (closed_or_open == 0)  # where nodes meet in the tube
            nodenormals[i, :] = mean(unitnormals[[numel, 1], :], dims=1)
        elseif (i != 1) & (closed_or_open == 0)  #tube
            nodenormals[i, :] = mean(unitnormals[i-1:i, :], dims=1)
        elseif (i == 1) & (closed_or_open == 1)  #open, first node is element norm
            nodenormals[i, :] = unitnormals[i, :]
        elseif (i != 1) & (i != numnodes) & (closed_or_open == 1)  #open
            nodenormals[i, :] = mean(unitnormals[i-1:i, :], dims=1)
        elseif (i == numnodes) & (closed_or_open == 1)  #open, last node is element norm
            nodenormals[i, :] = unitnormals[i-1, :]

        end

        #make sure unit normal always = 1.0
        unitnorm = norm(nodenormals[i, :])
        if unitnorm < 0.99
            scale = 1.0/unitnorm
            nodenormals[i,:] = scale .* nodenormals[i,:]
        end

    end

    return nodenormals

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