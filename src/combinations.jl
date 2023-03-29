struct CombinationSpace{V} <: AtomicSearchSpace
    values::V
    dim::Int
end

"""
    CombinationSpace(values; k)
    CombinationSpace(k)

Define a search space defined by the combinations (with replacement) of size k.

# Example

```julia-repl
julia> space = CombinationSpace(3)
CombinationSpace{UnitRange{Int64}}(1:3, 3)

julia> rand(space)
3-element Vector{Int64}:
 1
 1
 2

julia> rand(space,7)
7-element Vector{Vector{Int64}}:
 [1, 1, 1]
 [2, 1, 1]
 [2, 2, 1]
 [2, 3, 3]
 [1, 3, 1]
 [2, 1, 2]
 [2, 3, 1]

julia> rand(CombinationSpace([:apple, :orange, :onion, :garlic]))
4-element Vector{Symbol}:
 :apple
 :orange
 :orange
 :apple
```
"""
function CombinationSpace(values::AbstractVector; k = length(values))
    if length(values) > 0 && k > 0 
        return CombinationSpace(values, k)
    end
    error("Empty combinations are not allowed")
end

CombinationSpace(k::Int) = CombinationSpace(1:k, k)


function cardinality(searchspace::CombinationSpace)
    n = length(searchspace.values)
    r = searchspace.dim
    prod(n:BigInt(n + r - 1)) ÷ prod(2:BigInt(r))
end


function iscombination(x::AbstractVector, searchspace::CombinationSpace)
    if length(x) != searchspace.dim
        return false
    end 

    values = searchspace.values

    for v in x
        if v ∉ values
            return false
        end
    end
    true
end


isinspace(x, searchspace::CombinationSpace) = iscombination(x, searchspace)

#####################
# Related to SAMPLER
#####################
function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:CombinationSpace}
    parameters = sampler.method
    searchspace = sampler.searchspace

    if searchspace.dim == 1
        return rand(parameters.rng, searchspace.values)
    end

    rand(parameters.rng, searchspace.values, getdim(searchspace))
end

function Grid(searchspace::CombinationSpace; npartitions = 0)
    it = Combinatorics.with_replacement_combinations(searchspace.values, searchspace.dim)
    Sampler(Grid(npartitions, (it, nothing)), searchspace)
end

