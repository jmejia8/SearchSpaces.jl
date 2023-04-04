function GridSampler(searchspace::BitArraySpace; npartitions = 3)
    d = getdim(searchspace)
    it = Iterators.product(
                           ([false,true] for _ in 1:d)...
                          )

    Sampler(GridSampler(npartitions, (it, nothing)), searchspace)
end

function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:BitArraySpace}
    if getdim(sampler.searchspace) == 1
        return rand(sampler.method.rng, Bool)
    end
    
    rand(sampler.method.rng, Bool, getdim(sampler.searchspace))
end

