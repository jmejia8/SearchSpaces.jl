abstract type AbstractSampler end

struct RandomInDomain{R} <: AbstractSampler
    sample_size::Int
    rng::R
end

RandomInDomain(sample_size; rng = Random.default_rng()) = RandomInDomain(sample_size, rng)

struct Grid <: AbstractSampler
    npartitions::Int
    dim::Int
end
