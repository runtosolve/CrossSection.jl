using CrossSection, Unitful

joist_2_in = (H=8.0u"inch", B=2.0u"inch", D=0.56u"inch", t=0.075u"inch")

joist_2_in_geom, joist_2_in_props = CrossSection.calculate_open_thin_walled_section_properties(L=ustrip([joist_2_in.D, joist_2_in.B, joist_2_in.H, joist_2_in.B, joist_2_in.D]), θ=[π/2, π, -π/2, 0.0, π/2], r=fill(3*ustrip(joist_2_in.t), 4), n=[3, 3, 3, 3, 3], n_r=[3, 3, 3, 3], t=ustrip(joist_2_in.t));

CrossSection.Viz.plot_open_thin_walled_cross_section(joist_2_in_geom)