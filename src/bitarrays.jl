struct BitArrays <: AtomicSearchSpace
    dim::Int
end

"""
    BitArrays(;dim)

Define a search space delimited by bit arrays.
"""
BitArrays(;dim = 0) = BitArrays(dim)


"""
    cardinality(searchspace)

Cardinality of the search space
"""
function cardinality(searchspace::BitArrays)
    BigInt(2)^searchspace.dim
end


function Grid(searchspace::BitArrays; npartitions = 3)
    d = getdim(searchspace)
    it = Iterators.product(
                           ([false,true] for _ in 1:d)...
                          )

    Sampler(Grid(npartitions, (it, nothing)), searchspace)
end

function isbitarray(x::AbstractVector, searchspace::BitArrays)
    eltype(x) <: Bool && length(x) == getdim(searchspace)
end

isinspace(x, searchspace::BitArrays) = isbitarray(x, searchspace)

function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:BitArrays}
    if getdim(sampler.searchspace) == 1
        return rand(sampler.method.rng, Bool)
    end
    
    rand(sampler.method.rng, Bool, getdim(sampler.searchspace))
end
