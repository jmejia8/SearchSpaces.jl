struct MixedSpace{D, M} <: AbstractSearchSpace
    domain::D
    key_order::M
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
    MixedSpace(_get_domain_mixedspace(ps...), first.(ps))
end

"""
    A × B

Return the mixed space using Cartesian product.
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
_pre_proces_space(v::V) where  V<:AbstractVector = Categorical(v)


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

function Grid(searchspace::MixedSpace; npartitions = 3)
    ks = keys(searchspace.domain)
    it = Iterators.product((Grid(searchspace.domain[k];npartitions) for k in ks)...)

    Sampler(Grid(npartitions, (it, nothing)), searchspace, length(it))
end

function Sampler(sampler, searchspace::MixedSpace)
    ss = Dict(k => Sampler(sampler, searchspace.domain[k]) for k in keys(searchspace.domain))
    Sampler(ss, searchspace, cardinality(searchspace))
end


function value(sampler::Sampler{G, S}) where {G,S<:MixedSpace}
    ks = keys(sampler.searchspace.domain)
    Dict(k => value(sampler.method[k]) for k in ks)
end


function value(sampler::Sampler{G, S}) where {G<:Grid,S<:MixedSpace}
    it, n = sampler.method.iterator
    if isnothing(n)
        # first iteration call?
        res = iterate(it)
    else
        res = iterate(it, n)
    end

    # last iteration?
    if isnothing(res)
        sampler.method.iterator = (it, nothing)
        return nothing
    end

    val, next = res
    sampler.method.iterator = (it, next)

    ks = keys(sampler.searchspace.domain)

    Dict(k => v for (k, v) in zip(ks, val))
end

