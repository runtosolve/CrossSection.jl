using CrossSection

#generate a C-section joist
#https://sfia.memberclicks.net/assets/TechFiles/SFIA%20Tech%20Spec%202022%20%20%202.7.22%20Final.pdf

#800S200-54, from the SFIA catalog
t = 0.0566 #in.

#define outside dimensions
L = [0.625, 2.0, 8.0, 2.0, 0.625] #in.

#define cross-section element orientations
θ = [π/2, π, -π/2, 0.0, π/2]

#define outside bend radii
r = [0.0849 + t, 0.0849 + t, 0.0849 + t, 0.0849 + t]

#define cross-section discretization
n = [2, 2, 2, 2, 2, 2, 2]
n_r = [3, 3, 3, 3, 3, 3]


cross_section = CrossSection.generate_thin_walled(L, θ, n, r, n_r)
