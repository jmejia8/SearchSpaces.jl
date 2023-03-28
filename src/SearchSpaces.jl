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
include("combinations.jl")
include("mixedspace.jl")
include("variable.jl")
include("aliases.jl")

export MixedSpace, Grid, cardinality
export  isinbounds, ispermutation, Variable, @var, AtRandom, isinspace, CategorySpace
export ×
export iscombination
export BoxConstrainedSpace,PermutationSpace,BitArraySpace,CategorySpace, CombinationSpace

end
