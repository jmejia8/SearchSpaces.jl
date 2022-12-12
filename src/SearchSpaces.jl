module SearchSpaces

import Random

abstract type AbstractSearchSpace end
abstract type AtomicSearchSpace <: AbstractSearchSpace end

include("samplers.jl")
include("bitarrays.jl")
include("bounds.jl")
include("permutations.jl")
include("variable.jl")

export BitArrays, Bounds, Permutations, MixedSpace, Grid, cardinality, RandomInDomain
export sample, isinbounds, ispermutation, Variable, @var

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
    print(io, "MixedSpace defined by ", length(ks), " ")
    length(ks) != 1 ? println(io, "subspaces:") : println(io, "subspace:")
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
