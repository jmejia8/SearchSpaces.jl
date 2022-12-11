struct BitArrays <: AtomicSearchSpace
    dim::Int
end

"""
    BitArrays(;dim)

Define a search space delimited by bit arrays.
"""
BitArrays(;dim = 0) = BitArrays(dim)

function sample(method::Grid, searchspace::BitArrays)
    vals = Iterators.product(([false, true] for _ in 1:searchspace.dim)...)
    _X = reshape([x for val in vals for x in val], searchspace.dim, length(vals))
    Array(_X')
end

function sample(method::RandomInDomain, searchspace::BitArrays)
    rand(method.rng, Bool, method.sample_size, searchspace.dim)
end


"""
    cardinality(searchspace)

Cardinality of the search space
"""
function cardinality(searchspace::BitArrays)
    BigInt(2)^searchspace.dim
end

