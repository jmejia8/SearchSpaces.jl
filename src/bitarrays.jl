struct BitArrays <: AtomicSearchSpace
    dim::Int
end

"""
    BitArrays(;dim)

Define a search space delimited by bit arrays.
"""
BitArrays(;dim = 0) = BitArrays(dim)

#=
function sample(method::Grid, searchspace::BitArrays)
    vals = Iterators.product(([false, true] for _ in 1:searchspace.dim)...)
    _X = reshape([x for val in vals for x in val], searchspace.dim, length(vals))
    Array(_X')
end

function sample(method::RandomInDomain, searchspace::BitArrays)
    rand(method.rng, Bool, method.sample_size, searchspace.dim)
end
=#


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

function value(sampler::Sampler{R, P}) where {R<:AtRandom, P<:BitArrays}
    rand(sampler.method.rng, Bool, getdim(sampler.searchspace))
end
