using CrossSection
## joist

t = 0.0451 #in.
L = [0.563, 1.55, 8.05, 1.55, 0.56] #in.
θ = [π/2, π, -π/2, 0.0, π/2]
r = [0.18+t, 0.18+t, 0.18+t, 0.18+t]
n = [3, 3, 3, 3, 3]
n_r = [3, 3, 3, 3]

joist_geometry, joist = CrossSection.calculate_open_thin_walled_section_properties(L, θ, r, n, n_r, t)

#strong axis moment of inertia
joist.Ixx