module SearchSpaces

import Random
import Combinatorics

abstract type AbstractSearchSpace end
abstract type AtomicSearchSpace <: AbstractSearchSpace end

include("samplers.jl")
include("common.jl")
include("bitarrays.jl")
include("bounds.jl")
include("permutations.jl")
include("categorical.jl")
include("mixedspace.jl")
include("variable.jl")

export BitArrays, Bounds, Permutations, MixedSpace, Grid, cardinality, RandomInDomain
export  isinbounds, ispermutation, Variable, @var, AtRandom, isinspace, Categorical

end
