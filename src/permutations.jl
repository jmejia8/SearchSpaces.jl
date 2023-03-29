struct PermutationSpace{V} <: AtomicSearchSpace
    values::V
    dim::Int
end


function PermutationSpace(perm_size::Integer = 0; values = collect(1:perm_size))
    if perm_size == 0
        perm_size = length(values)
    end
    
    @assert perm_size > 0 "Empty permutation is not allowed"

    PermutationSpace(values, perm_size)
end

"""
    PermutationSpace(values; k)
    PermutationSpace(k)

Define a search space defined by permuting the values of size k (k-permutations).

```julia-repl
julia> space = PermutationSpace([:red, :green, :blue])
PermutationSpace{Vector{Symbol}}([:red, :green, :blue], 3)

julia> rand(space, 5)
5-element Vector{Vector{Symbol}}:
 [:blue, :green, :red]
 [:red, :blue, :green]
 [:blue, :green, :red]
 [:green, :blue, :red]
 [:red, :blue, :green]

julia> Grid(PermutationSpace(3)) |> collect
6-element Vector{Any}:
 [1, 2, 3]
 [1, 3, 2]
 [2, 1, 3]
 [2, 3, 1]
 [3, 1, 2]
 [3, 2, 1]
```
"""
function PermutationSpace(values::AbstractVector; k = length(values))
    @assert k > 0 "Empty permutation is not allowed"
    PermutationSpace(values, k)
end

function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:PermutationSpace}
    parameters = sampler.method
    searchspace = sampler.searchspace
    if searchspace.dim == length(searchspace.values)
        return Random.shuffle(parameters.rng, searchspace.values)
    end

    if searchspace.dim == 1
        return rand(parameters.rng, searchspace.values)
    end

    # TODO improve this
    Random.shuffle(parameters.rng, searchspace.values)[1:getdim(searchspace)]
end

function cardinality(searchspace::PermutationSpace)
    n = length(searchspace.values)
    r = searchspace.dim
    prod((n-r+1):BigInt(n))
end

function ispermutation(x::AbstractVector{<:Integer}, searchspace::PermutationSpace)
    if length(x) != searchspace.dim
        return false
    end

    # @assert maximum(x) == length(x)

    mask = zeros(Bool, length(x))
    mask[x] .= true
    all(mask)
end


function ispermutation(x::AbstractVector, searchspace::PermutationSpace)
    if length(x) != searchspace.dim
        return false
    end 

    x = unique(x)
    if length(x) != searchspace.dim
        return false
    end 

    values = searchspace.values

    for (i, v) in enumerate(x)
        if v ∉ values
            return false
        end
    end
    true
end



"""
    ispermutation(item, searchspace) --> Bool

Determine whether an item is in the given searchspace.
"""
ispermutation(x, searchspace::PermutationSpace) = x in searchspace.values

"""
    isinspace(item, searchspace) --> Bool

Determine whether an item is in the given searchspace.

See also [`in`](@ref).
"""
isinspace(x, searchspace::PermutationSpace) = ispermutation(x, searchspace)

function Grid(searchspace::PermutationSpace; npartitions = 0)
    it = Combinatorics.permutations(searchspace.values, searchspace.dim)
    Sampler(Grid(npartitions, (it, nothing)), searchspace)
end

