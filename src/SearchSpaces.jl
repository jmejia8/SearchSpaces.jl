module SearchSpaces

import Random
import Combinatorics

abstract type AbstractSearchSpace end
abstract type AtomicSearchSpace <: AbstractSearchSpace end

include("samplers/sampler.jl")
include("common.jl")
include("spaces/spaces.jl")
include("variable.jl")
include("aliases.jl")

export MixedSpace, GridSampler, cardinality
export  isinbounds, ispermutation, Variable, @var, RandomSampler, isinspace, CategorySpace
export ×
export ..
export iscombination
export BoxConstrainedSpace,PermutationSpace,BitArraySpace,CategorySpace, CombinationSpace
export PolygonConstrainedSpace
end
