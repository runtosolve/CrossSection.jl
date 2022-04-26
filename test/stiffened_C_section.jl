using CrossSection


L = [0.75, 2.0, 4.0, 0.75]
θ = [π/2, π, 3π/2, 0.0]
n_radius = [3, 3, 3]
n = [4, 4, 4, 4]
r = 0.09 * ones(Float64, 3)

cross_section = CrossSection.generate_open(L, θ, r, n, n_radius)


using Plots
plot(cross_section[:,1], cross_section[:, 2], markershape = :o)