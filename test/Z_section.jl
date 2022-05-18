using CrossSection, Plots


cross_section_dimensions = [("Z", 0.059, 0.91, 2.5, 8.0, 2.5, 0.91, -55.0, 0.0, 90.0, 0.0, -55.0, 3*0.059, 3*0.059, 3*0.059, 3*0.059)]

t = 0.059 * 2
d_bottom = 0.91
b_bottom = 2.5
h = 8.0
b_top = 2.5
d_top = 0.91

Θ_bottom_lip = -55.0
Θ_bottom_flange = 0.0
Θ_web = 90.0
Θ_top_flange = 0.0
Θ_top_lip = -55.0

r_bottom_flange_lip = 3*t
r_bottom_flange_web = 3*t
r_top_flange_web = 3*t
r_top_flange_lip = 3*t 

n = [2, 2, 5, 2, 2]   #change these to make things run faster
n_r = [3, 3, 3, 3]

###########


#First calculate the correction on out-to-out length to go from the outside surface to the inside bottom flange surface.
delta_lip_bottom = t / tan((π - deg2rad(abs(Θ_bottom_flange - Θ_bottom_lip))) / 2)
delta_web_bottom = t / tan((π - deg2rad(abs(Θ_web - Θ_bottom_flange))) / 2)

#Note here that the bottom flange and lip dimensions are smaller here.
L = [d_bottom - delta_lip_bottom, b_bottom - delta_lip_bottom - delta_web_bottom, h - delta_web_bottom, b_top, d_top]
θ = deg2rad.([Θ_bottom_lip, Θ_bottom_flange, Θ_web, Θ_top_flange, Θ_top_lip])

#Note that the outside radius is used at the top flange, and the inside radius is used for the bottom flange.
r = [r_bottom_flange_lip - t, r_bottom_flange_web - t, r_top_flange_web, r_top_flange_lip]

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

# #Shift y coordinates so that the bottom purlin face is at y = 0.
# ycoords_center = ycoords_center .- minimum(ycoords_center) .+ t/2

# #Shift x coordinates so that the purlin web centerline is at x = 0.
# index = floor(Int, length(xcoords_center)/2)
# xcoords_center = xcoords_center .- xcoords_center[index]

plot!(xcoords_center, ycoords_center, markershape = :o, aspect_ratio=:equal)