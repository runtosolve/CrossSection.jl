using CrossSection

edge_width = 215.0 - 162.0
flute_width = 162.0 - 137.0
flute_space = 137.0 - 112.0
flute_web_length = 8.0

flute_web_angle = π/2

num_flutes = 7

L, θ = CrossSection.define_fluted_deck_cross_section(edge_width, flute_width, flute_web_length, flute_space, flute_web_angle, num_flutes)

