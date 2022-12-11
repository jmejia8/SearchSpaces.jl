module SearchSpaces

import Random

abstract type AbstractSearchSpace end
abstract type AtomicSearchSpace <: AbstractSearchSpace end

include("samplers.jl")
include("BitArrays.jl")
include("Bounds.jl")
include("Permutations.jl")

export BitArrays, Bounds, Permutations, MixedSpace, Grid, cardinality, RandomInDomain
export sample, isinbounds, ispermutation

struct MixedSpace{D, M} <: AbstractSearchSpace
    domain::D
    meta::M
end

"""
    MixedSpace([itr])

Construct a search space.

### Examples
```julia-repl
julia> MixedSpace( :X => Bounds(lb = [-1.0, -3.0], ub = [10.0, 10.0]),
                   :Y => Permutations(10),
                   :Z => BitArrays(dim = 10)
                   ) 
```
"""
function MixedSpace(ps::Pair...)
    MixedSpace(Dict(ps), nothing)
end

function Base.show(io::IO, searchspace::MixedSpace)
    ks = keys(searchspace.domain)
    println(io, "MixedSpace with ", length(ks), " variables:")
    for k in ks
        println(io, k, " => ", searchspace.domain[k])
    end
end


function sample(parameters::RandomInDomain, searchspace::MixedSpace)
    Dict(
         k => sample(parameters, searchspace.domain[k])
         for k in keys(searchspace.domain)
        )
end



function cardinality(searchspace::MixedSpace)
    prod(cardinality(searchspace.domain[k]) for k in keys(searchspace.domain))
end

end # module
