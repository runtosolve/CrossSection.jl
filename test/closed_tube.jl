using CrossSection

L = [5.0, 5.0, 5.0, 5.0]
θ = [0.0, π/2, π, 3π/2]
n = [3, 3, 3, 3]
r = [0.09, 0.09, 0.09, 0.09]
n_r = [3, 3, 3, 3]


#two methods

#with corner radii
cross_section = CrossSection.generate_thin_walled(L, θ, n, r, n_r)


#straight corner
cross_section = CrossSection.generate_thin_walled(L, θ, n)

