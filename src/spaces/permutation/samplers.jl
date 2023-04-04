function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:PermutationSpace}
    parameters = sampler.method
    searchspace = sampler.searchspace
    if searchspace.dim == length(searchspace.values)
        return Random.shuffle(parameters.rng, searchspace.values)
    end

    if searchspace.dim == 1
        return rand(parameters.rng, searchspace.values)
    end

    # TODO improve this
    Random.shuffle(parameters.rng, searchspace.values)[1:getdim(searchspace)]
end

function get_iterator(searchspace::PermutationSpace; kargs...)
    Combinatorics.permutations(searchspace.values, searchspace.dim)
end

