module SearchSpaces

import Random

abstract type AbstractSearchSpace end
abstract type AtomicSearchSpace <: AbstractSearchSpace end

include("samplers.jl")
include("BitArrays.jl")
include("Bounds.jl")
include("Permutations.jl")

export BitArrays, Bounds, Permutations, SearchSpace, Grid, cardinality, RandomInDomain
export sample, isinbounds, ispermutation

struct SearchSpace{D, M} <: AbstractSearchSpace
    domain::D
    meta::M
end

"""
    SearchSpace([itr])

Construct a search space.

### Examples
```julia-repl
julia> SearchSpace(:x => Bounds(lb = [-1.0, -3.0],
                                ub = [10.0, 10.0]),
                   :y => Permutations(10),
                   :z => BitArrays(dim = 10)
                   ) 
```
"""
function SearchSpace(ps::Pair...)
    SearchSpace(Dict(ps), nothing)
end

function Base.show(io::IO, searchspace::SearchSpace)
    ks = keys(searchspace.domain)
    println(io, "SearchSpace with ", length(ks), " variables:")
    for k in ks
        println(io, k, " => ", searchspace.domain[k])
    end
end


function sample(parameters::RandomInDomain, searchspace::SearchSpace)
    Dict(
         k => sample(parameters, searchspace.domain[k])
         for k in keys(searchspace.domain)
        )
end



function cardinality(searchspace::SearchSpace)
    prod(cardinality(searchspace.domain[k]) for k in keys(searchspace.domain))
end

end # module
