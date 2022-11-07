using CrossSection

# 4x4x3/16 tube

t = 3/16 #in.
L = [4.0, 4.0, 4.0, 4.0] #in.
θ = [0.0, π/2, π, -π/2]
r = [3*t, 3*t, 3*t, 3*t]
n = [3, 3, 3, 3]
n_r = [3, 3, 3, 3]

post_geometry, post = CrossSection.calculate_closed_thin_walled_section_properties(L, θ, r, n, n_r, t)

#cross-sectional area
post.A