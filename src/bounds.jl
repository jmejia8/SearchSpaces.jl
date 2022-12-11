struct Bounds{T} <: AtomicSearchSpace
    lb::Vector{T} # lower bounds
    ub::Vector{T} # upper bounds
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
function Bounds(;lb::AbstractVector = zeros(0), ub::AbstractVector=zeros(0), rigid=true)
    @assert _valid_bounds(lb, ub) "Check size of lb and ub, and also lb[i] <= ub[i]."

    Bounds(lb, ub, length(lb), rigid)
end


function sample(method::RandomInDomain, searchspace::Bounds)
    a = searchspace.lb'
    b = searchspace.ub'
    # scale sample
    a .+ (b - a) .* rand(method.rng, method.sample_size)
end

function sample(method::AbstractSampler, searchspace::Bounds)
    bounds = [searchspace.lb'; searchspace.ub']
    sample(method, bounds)
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

