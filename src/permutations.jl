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

#=
function sample(parameters::RandomInDomain, searchspace::Permutations)
    D = searchspace.dim
    X = zeros(Int, parameters.sample_size, D)
    sample_size = parameters.sample_size
    for i in 1:parameters.sample_size
        X[i,:] = Random.shuffle(parameters.rng, 1:D)
    end
    X
end
=#

function value(sampler::Sampler{R, P}) where {R<:AtRandom, P<:Permutations}
    parameters = sampler.method
    Random.shuffle(parameters.rng, sampler.searchspace.values)
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


function Grid(searchspace::Permutations; npartitions = 0)
    it = Combinatorics.permutations(searchspace.values)
    Sampler(Grid(npartitions, (it, nothing)), searchspace)
end

isinspace(x, searchspace::Permutations) = ispermutation(x, searchspace)
