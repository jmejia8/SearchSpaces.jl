abstract type AbstractSampler end

struct Sampler{M, S} <: AbstractSampler
    method::M
    searchspace::S
    len::Union{Int, BigInt, Float64, BigFloat}
end

function Sampler(sampler, searchspace::AtomicSearchSpace)
    Sampler(sampler, searchspace, cardinality(searchspace))
end

function Base.iterate(S::Sampler, state=1)
    val = value(S)
    if isnothing(val)
        return nothing
    end

    val, state + 1
end

struct AtRandom{R} <: AbstractSampler
    rng::R
end

function AtRandom(searchspace::AbstractSearchSpace; rng=Random.default_rng())
    Sampler(AtRandom(rng), searchspace)
end

mutable struct Grid <: AbstractSampler
    npartitions::Int
    iterator::Tuple
end


function value(sampler::Sampler{G, S}) where {G<:Grid,S<:AtomicSearchSpace}
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
    [v for v in val]
end


Base.length(sampler::Sampler{S, B}) where {S<:Grid,B} = sampler.len
Base.size(sampler::Sampler{S, B}) where {S<:Grid,B} = (sampler.len,)
Base.IsInfinite(sampler::Sampler{S, B}) where {S<:AtRandom,B} = true

