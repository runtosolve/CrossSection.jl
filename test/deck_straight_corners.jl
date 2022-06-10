using CrossSection, Plots


d = 50.0
s = 30.0
w = 25.0

L = [25.0 + s, d, w, d, s, d, w, d, 25.0 + s]

α_d = π/2

θ = [0.0, -α_d, 0.0, α_d, 0.0, -α_d, 0.0, α_d, 0.0]

n = [3, 3, 3, 3, 3, 3, 3, 3, 3]


cross_section = CrossSection.generate_thin_walled(L, θ, n)

X = [cross_section[i][1] for i in eachindex(cross_section)]
Y = [cross_section[i][2] for i in eachindex(cross_section)]


plot(X, Y)