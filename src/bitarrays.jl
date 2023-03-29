struct BitArraySpace <: AtomicSearchSpace
    dim::Int
end

"""
    BitArraySpace(;dim)

Define a search space delimited by bit arrays.

# Example

```julia-repl
julia> space = BitArraySpace(4)
BitArraySpace(4)

julia> rand(space, 7)
7-element Vector{Vector{Bool}}:
 [0, 1, 1, 0]
 [0, 0, 0, 1]
 [1, 1, 1, 0]
 [0, 0, 0, 1]
 [0, 1, 0, 1]
 [1, 1, 1, 0]
 [1, 0, 0, 0]
```

"""
BitArraySpace(;dim = 0) = BitArraySpace(dim)


"""
    cardinality(searchspace)

Cardinality of the search space.

# Example

```julia-repl
julia> cardinality(PermutationSpace(5))
120

julia> cardinality(BoxConstrainedSpace(lb = zeros(2), ub = ones(2)))
Inf

julia> cardinality(BoxConstrainedSpace(lb = zeros(Int, 2), ub = ones(Int,2)))
4

julia> mixed = MixedSpace(
                          :W => CategorySpace([:red, :green, :blue]),
                          :X => PermutationSpace(3),
                          :Y => BitArraySpace(3),
                         );

julia> cardinality(mixed)
144
```
"""
function cardinality(searchspace::BitArraySpace)
    BigInt(2)^searchspace.dim
end

function Grid(searchspace::BitArraySpace; npartitions = 3)
    d = getdim(searchspace)
    it = Iterators.product(
                           ([false,true] for _ in 1:d)...
                          )

    Sampler(Grid(npartitions, (it, nothing)), searchspace)
end

function isbitarray(x::AbstractVector{T}, searchspace::BitArraySpace) where T<:Bool
    length(x) == getdim(searchspace)
end

isbitarray(x, searchspace::BitArraySpace) = false
isinspace(x, searchspace::BitArraySpace) = isbitarray(x, searchspace)

function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:BitArraySpace}
    if getdim(sampler.searchspace) == 1
        return rand(sampler.method.rng, Bool)
    end
    
    rand(sampler.method.rng, Bool, getdim(sampler.searchspace))
end

