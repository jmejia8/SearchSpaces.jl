function GridSampler(searchspace::MixedSpace; npartitions = 3)
    ks = keys(searchspace.domain)
    it = Iterators.product((GridSampler(searchspace.domain[k];npartitions) for k in ks)...)

    Sampler(GridSampler(npartitions, (it, nothing)), searchspace, length(it))
end

function Sampler(sampler, searchspace::MixedSpace)
    ss = Dict(k => Sampler(sampler, searchspace.domain[k]) for k in keys(searchspace.domain))
    Sampler(ss, searchspace, cardinality(searchspace))
end


function value(sampler::Sampler{G, S}) where {G,S<:MixedSpace}
    ks = keys(sampler.searchspace.domain)
    Dict(k => value(sampler.method[k]) for k in ks)
end


function value(sampler::Sampler{G, S}) where {G<:GridSampler,S<:MixedSpace}
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

