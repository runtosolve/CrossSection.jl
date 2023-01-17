using CrossSection, Unitful  

t=0.071
L = [1.25-t, 4.5-t, 2.25, 0.25] #in.
θ = [π, π/2, π, (π+π/4)]
r = [2*t, 3*t, 3*t]
n = [2, 2, 2, 2]
n_r = [3, 3, 3]


typeof(unit(t)) == Unitful.FreeUnits{(), NoDims, nothing}

Geometry.lay_out_cross_section_nodes(L, θ)

Geometry.generate_thin_walled(L, θ, n, r, n_r)