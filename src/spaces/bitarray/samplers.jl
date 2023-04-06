function get_iterator(searchspace::BitArraySpace;kargs...)
    d = getdim(searchspace)
    Iterators.product(([false,true] for _ in 1:d)...)
end

function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:BitArraySpace}
    if getdim(sampler.searchspace) == 1
        return rand(sampler.method.rng, Bool)
    end
    
    rand(sampler.method.rng, Bool, getdim(sampler.searchspace))
end

