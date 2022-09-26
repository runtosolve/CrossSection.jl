using CrossSection, Plots

#https://www.metalpanelsinc.com/portfolio-item/pbr-panel/

L = [
0.5
1.25/sind(48.0)
(4.0-1.0/2-0.75/2-1.25/sind(48.0)*cosd(48.0))
(3/16)/sind(48.0)
0.75
(3/16)/sind(48.0)
(4.0-1.375)
(3/16)/sind(48.0)
0.75
(3/16)/sind(48.0)
(4.0-1.0/2-0.75/2-1.25/sind(48.0)*cosd(48.0))
1.25/sind(48.0)
1.0

1.25/sind(48.0)
(4.0-1.0/2-0.75/2-1.25/sind(48.0)*cosd(48.0))
(3/16)/sind(48.0)
0.75
(3/16)/sind(48.0)
(4.0-1.375)
(3/16)/sind(48.0)
0.75
(3/16)/sind(48.0)
(4.0-1.0/2-0.75/2-1.25/sind(48.0)*cosd(48.0))
1.25/sind(48.0)
1.0

1.25/sind(48.0)
(4.0-1.0/2-0.75/2-1.25/sind(48.0)*cosd(48.0))
(3/16)/sind(48.0)
0.75
(3/16)/sind(48.0)
(4.0-1.375)
(3/16)/sind(48.0)
0.75
(3/16)/sind(48.0)
(4.0-1.0/2-0.75/2-1.25/sind(48.0)*cosd(48.0))
1.25/sind(48.0)
0.5]

θ = [

0.0
-48.0
0.0
48.0
0.0
-48.0
0.0
48.0
0.0
-48.0
0.0
48.0
0.0

-48.0
0.0
48.0
0.0
-48.0
0.0
48.0
0.0
-48.0
0.0
48.0
0.0

-48.0
0.0
48.0
0.0
-48.0
0.0
48.0
0.0
-48.0
0.0
48.0
0.0]

θ = deg2rad.(θ)

n = ones(Int64, length(θ)) .* 3


cross_section = CrossSection.generate_thin_walled(L, θ, n)

X = [cross_section[i][1] for i in eachindex(cross_section)]
Y = [cross_section[i][2] for i in eachindex(cross_section)]

plot(X, Y, markershape = :o, aspect_ratio=:equal)