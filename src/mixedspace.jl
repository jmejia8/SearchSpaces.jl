
struct MixedSpace{D, M} <: AbstractSearchSpace
    domain::D
    meta::M
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
    MixedSpace(Dict(ps), nothing)
end

function Base.show(io::IO, searchspace::MixedSpace)
    ks = keys(searchspace.domain)
    print(io, "MixedSpace defined by ", length(ks), " ")
    length(ks) != 1 ? println(io, "subspaces:") : println(io, "subspace:")
    for k in ks
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

