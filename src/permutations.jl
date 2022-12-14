struct Permutations{I, V} <: AtomicSearchSpace
    indices::I
    values::V
    dim::Int
end


"""
    Permutations(perm_size; values=1:perm_size)

Define a search space defined by permuting the values of size perm_size.
"""
function Permutations(perm_size::Integer = 0; values = collect(1:perm_size))
    if perm_size == 0
        perm_size = length(values)
    end
    
    @assert perm_size > 0 "Empty permutation is not allowed"
    @assert perm_size == length(values) "Permutations size and values array must be the same."

    Permutations(collect(1:perm_size), values, perm_size)
end

function Permutations(values::AbstractVector, perm_size = length(values))
    @assert perm_size > 0 "Empty permutation is not allowed"
    Permutations(collect(1:perm_size), values, perm_size)
end

function value(sampler::Sampler{R, P}) where {R<:AtRandom, P<:Permutations}
    parameters = sampler.method
    searchspace = sampler.searchspace
    if searchspace.dim == length(searchspace.values)
        return Random.shuffle(parameters.rng, searchspace.values)
    end

    # TODO improve this
    Random.shuffle(parameters.rng, searchspace.values)[1:getdim(searchspace)]
end

function cardinality(searchspace::Permutations)
    prod(1:BigInt(searchspace.dim))
end

function ispermutation(x::AbstractVector{<:Integer}, searchspace::Permutations)
    if length(x) != searchspace.dim
        return false
    end

    # @assert maximum(x) == length(x)

    mask = zeros(Bool, length(x))
    mask[x] .= true
    all(mask)
end

function ispermutation(x::AbstractVector, searchspace::Permutations)
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


function Grid(searchspace::Permutations; npartitions = 0)
    it = Combinatorics.permutations(searchspace.values, searchspace.dim)
    Sampler(Grid(npartitions, (it, nothing)), searchspace)
end

isinspace(x, searchspace::Permutations) = ispermutation(x, searchspace)
