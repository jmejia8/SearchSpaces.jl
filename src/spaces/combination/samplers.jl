#####################
# Related to SAMPLER
#####################
function value(sampler::Sampler{R, P}) where {R<:AbstractRNGSampler, P<:CombinationSpace}
    parameters = sampler.method
    searchspace = sampler.searchspace

    if searchspace.dim == 1
        return rand(parameters.rng, searchspace.values)
    end

    rand(parameters.rng, searchspace.values, getdim(searchspace))
end

function GridSampler(searchspace::CombinationSpace; npartitions = 0)
    it = Combinatorics.with_replacement_combinations(searchspace.values, searchspace.dim)
    Sampler(GridSampler(npartitions, (it, nothing)), searchspace)
end

