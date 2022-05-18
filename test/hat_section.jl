using CrossSection 

 t = 0.060
 d_top_minus_y = 0.5
 b_top_minus_y = 1.5
 h_minus_y = 3.5
 b_bottom = 1.0
 h_plus_y = 3.5
 b_top_plus_y = 1.5
 d_top_plus_y = 0.5
 α1 = 45.0
 α2 = 0.0
 α3 = -90.0
 α4 = 0.0
 α5 = 90.0
 α6 = 0.0
 α7 = -45.0
 r1 = 0.25  #outside radius
 r2 = 0.25
 r3 = 0.25
 r4 = 0.25
 r5 = 0.25
 r6 = 0.25

 #Define straight-line lengths on the top cross-section surface.   
 L = [d_top_minus_y, b_top_minus_y, h_minus_y - t, b_bottom - 2*t, h_plus_y - t, b_top_plus_y, d_top_plus_y]
 θ = deg2rad.([α1, α2, α3, α4, α5, α6, α7])

 #Note that the outside radius is used at the top flanges, and the inside radius is used for the bottom flange.
 r = [r1, r2, r3-t, r4-t, r5, r6]

 n = [2, 2, 6, 2, 6, 2, 2]
 n_r = [3, 3, 3, 3, 3, 3]

 cross_section = CrossSection.generate_thin_walled(L, θ, n, r, n_r)


 X = [cross_section[i][1] for i in eachindex(cross_section)]
 Y = [cross_section[i][2] for i in eachindex(cross_section)]
 
 plot(X, Y, markershape = :o, aspect_ratio = :equal)
 
 
 #Get node normals on cross-section
 unit_node_normals = CrossSection.Tools.calculate_cross_section_unit_node_normals(cross_section)
 #Get centerline coords
 centerline = CrossSection.Tools.get_coords_along_node_normals(cross_section, unit_node_normals, t/2)
 
 
 xcoords_center = [centerline[i][1] for i in eachindex(cross_section)]
 ycoords_center = [centerline[i][2] for i in eachindex(cross_section)]

 plot!(xcoords_center,  ycoords_center, markershape = :o, aspect_ratio = :equal)


 #Shift y coordinates so that the bottom face is at y = 0.
 ycoords_center = ycoords_center .- minimum(ycoords_center) .+ t/2

 #Shift x coordinates so that the section centerline is at x = 0.
 index = n[1] + n[2] + n[3] + floor(Int, n[4]/2) + n_r[1] + n_r[2] + n_r[3] + 1
 xcoords_center = xcoords_center .- xcoords_center[index]

 #Package nodal geometry.
 node_geometry = [xcoords_center ycoords_center]

 plot!(xcoords_center,  ycoords_center, markershape = :o, aspect_ratio = :equal)
