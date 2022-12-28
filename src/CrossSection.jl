module CrossSection

export Geometry
include("Geometry.jl")
using .Geometry

export Properties
include("Properties.jl")
using .Properties

export Shapes
include("Shapes.jl")
using .Shapes


end # module
