abstract type AbstractSampler end
abstract type AbstractRNGSampler end

struct Sampler{M, S} <: AbstractSampler
    method::M
    searchspace::S
    len::Union{Int, BigInt, Float64, BigFloat}
end

include("grid.jl")
include("random.jl")

"""
    Sampler(sampler, searchspace)

Crate an iterator for the sampler for the given searchspace.
"""
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

