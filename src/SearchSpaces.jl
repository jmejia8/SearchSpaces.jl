module SearchSpaces

import Random
import Combinatorics

abstract type AbstractSearchSpace end
abstract type AtomicSearchSpace <: AbstractSearchSpace end

include("common.jl")
include("samplers.jl")
include("bitarrays.jl")
include("bounds.jl")
include("permutations.jl")
include("mixedspace.jl")
include("variable.jl")

export BitArrays, Bounds, Permutations, MixedSpace, Grid, cardinality, RandomInDomain
export  isinbounds, ispermutation, Variable, @var, AtRandom, isinspace

end
