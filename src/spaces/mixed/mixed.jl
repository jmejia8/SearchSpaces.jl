struct MixedSpace{D, M} <: AbstractSearchSpace
    domain::D
    key_order::M
end

"""
    MixedSpace([itr])

Construct a search space.

# Example

```julia-repl
julia> space = MixedSpace( :X => BoxConstrainedSpace(lb = [-1.0, -3.0], ub = [10.0, 10.0]),
                          :Y => PermutationSpace(10),
                          :Z => BitArraySpace(dim = 10)
                          ) 
MixedSpace defined by 3 subspaces:
X => BoxConstrainedSpace{Float64}([-1.0, -3.0], [10.0, 10.0], [11.0, 13.0], 2, true)
Y => PermutationSpace{Vector{Int64}}([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10)
Z => BitArraySpace(10)


julia> rand(space)
Dict{Symbol, Vector} with 3 entries:
  :Z => Bool[0, 1, 0, 0, 0, 0, 0, 1, 1, 0]
  :X => [0.367973, 4.62101]
  :Y => [4, 3, 9, 1, 7, 2, 10, 8, 5, 6]
```

See also [`×`](@ref)
"""
function MixedSpace(ps::Pair...)
    MixedSpace(_get_domain_mixedspace(ps...), first.(ps))
end

"""
    A × B

Return the mixed space using Cartesian product.

# Example

```julia-repl
julia> bounds = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5));

julia> permutations = PermutationSpace([:red, :green, :blue]);

julia> bits = BitArraySpace(3);

julia> mixed = bounds × permutations × bits
MixedSpace defined by 3 subspaces:
S3 => BitArraySpace(3)
S2 => PermutationSpace{Vector{Symbol}}([:red, :green, :blue], 3)
S1 => BoxConstrainedSpace{Int64}([0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], 5, true)

julia> cardinality(mixed)
1536

julia> rand(mixed)
Dict{Symbol, Vector} with 3 entries:
  :S2 => [:red, :blue, :green]
  :S1 => [0, 1, 0, 0, 1]
  :S3 => Bool[1, 1, 0]
```
"""
function (×)(S::T, S2::T2) where {T<:AtomicSearchSpace,T2<:AtomicSearchSpace}
    MixedSpace(:S1 => S, :S2 => S2)
end

function _prod_spaces(_D::T, S2::T2) where {T<:MixedSpace,T2<:AtomicSearchSpace}
    D = _D.domain
    k = Symbol("S" * string(length(D) + 1))
    MixedSpace(k => S2, D...)
end

(×)(_D::T, S2::T2) where {T<:MixedSpace,T2<:AtomicSearchSpace} = _prod_spaces(_D, S2)
(×)(_D::T, S2::T2) where {T<:AtomicSearchSpace,T2<:MixedSpace} = _prod_spaces(S2, _D)

_get_domain_mixedspace(ps::Pair...) = Dict(first(v) => _pre_proces_space(last(v)) for v in ps)

# add here how to build mixed spaces
_pre_proces_space(v::V) where  V<:AbstractSearchSpace = v
_pre_proces_space(v::V) where  V<:AbstractVector = CategorySpace(v)


function Base.show(io::IO, searchspace::MixedSpace)
    ks = keys(searchspace.domain)
    print(io, "MixedSpace defined by ", length(ks), " ")
    length(ks) != 1 ? println(io, "subspaces:") : println(io, "subspace:")
    for k in searchspace.key_order
        println(io, k, " => ", searchspace.domain[k])
    end
end

function cardinality(searchspace::MixedSpace)
    prod(cardinality(searchspace.domain[k]) for k in keys(searchspace.domain))
end


function getdim(searchspace::MixedSpace)
    sum(getdim(searchspace.domain[k]) for k in keys(searchspace.domain))
end


function isinspace(x::Dict, searchspace::MixedSpace)
    ks = keys(searchspace.domain)
    if keys(x) != ks
        return false
    end
    
    all(isinspace(x[k], searchspace.domain[k]) for k in ks)
end

isinspace(x, searchspace::MixedSpace) = false

