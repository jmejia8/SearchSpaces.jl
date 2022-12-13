struct Bounds{T} <: AtomicSearchSpace
    lb::Vector{T} # lower bounds
    ub::Vector{T} # upper bounds
    Δ::Vector{T}  # = ub-lb
    dim::Int
    rigid::Bool
end

function _valid_bounds(lb, ub)
    if length(lb) != length(ub) || any(lb .> ub)
        return false
    end

    true
end

"""
    Bounds(;lb, ub, rigid=true)

Define a search space delimited by box constraints.
"""
function Bounds(lb::AbstractVector, ub::AbstractVector; rigid=true)
    @assert _valid_bounds(lb, ub) "Check size of lb and ub, and also lb[i] <= ub[i]."

    Bounds(lb, ub, ub - lb, length(lb), rigid)
end

function Bounds(;lb = zeros(0), ub = zeros(0), rigid=true)
    Bounds(lb, ub; rigid)
end

function Bounds(lb::Real, ub::Real; rigid=true)
    lb, ub = promote(lb, ub)
    Bounds([lb], [ub]; rigid)
end

function cardinality(searchspace::Bounds{T}) where T <: Integer
    prod(searchspace.ub - searchspace.lb .+ one(T))
end

function cardinality(searchspace::Bounds)
    Inf
end

function isinbounds(x, searchspace::Bounds)
    all(searchspace.lb .<= x .<= searchspace.ub)
end

isinspace(x, searchspace::Bounds) = isinbounds(x, searchspace)

function _get_random(bounds::Bounds{<:Integer}, rng)
    [rand(rng, a:b) for (a, b) in zip(bounds.lb, bounds.ub)]
end

function _get_random(bounds::Bounds, rng)
    bounds.lb + bounds.Δ .* rand(rng, getdim(bounds))
end

function value(sampler::Sampler{S, B}) where {S<:AtRandom,B<:Bounds}
    parameters = sampler.method
    searchspace = sampler.searchspace
    _get_random(searchspace, parameters.rng)
end

function Grid(bnds::Bounds{T}; npartitions = 3) where T <: Integer
    d = getdim(bnds)
    it = Iterators.product(
                           (a:b for (a, b) in zip(bnds.lb, bnds.ub))...
                          )

    Sampler(Grid(npartitions, (it, nothing)), bnds, BigInt(npartitions)^d)
end

function Grid(bnds::Bounds; npartitions = 3)
    d = getdim(bnds)

    it = Iterators.product(
                           (
                            range(a, b, length = npartitions) 
                            for (a, b) in zip(bnds.lb, bnds.ub)
                           )...
                          )

    Sampler(Grid(npartitions, (it, nothing)), bnds, BigInt(npartitions)^d)
end

