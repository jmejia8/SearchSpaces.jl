"""
    RandomSampler(searchspace;rng)

Define a random iterator for the search space.
"""
struct RandomSampler{R} <: AbstractRNGSampler
    rng::R
end

function RandomSampler(searchspace::AbstractSearchSpace; rng=Random.default_rng())
    Sampler(RandomSampler(rng), searchspace)
end


Base.IsInfinite(sampler::Sampler{S, B}) where {S<:AbstractRNGSampler,B} = true

"""
    rand([rng=GLOBAL_RNG], searchspace, [d])

Pick a random element or array of random elements from the search space specified by searchspace.

### Examples

```julia-repl
julia> searchspace = BoxConstrainedSpace(lb=[-10, 1, 100], ub = [10, 2, 1000]);

julia> rand(searchspace)
3-element Vector{Int64}:
   1
   1
 606

julia> rand(searchspace, 3)
3-element Vector{Vector{Int64}}:
 [0, 1, 440]
 [9, 1, 897]
 [3, 2, 498]
```

Another example using `MixedSpace`:

```julia-repl
julia> mixed = MixedSpace(
                          :W => CategorySpace([:red, :green, :blue]),
                          :X => PermutationSpace(3),
                          :Y => BitArrays(3),
                          :Z => BoxConstrainedSpace(lb = zeros(2), ub = ones(2))
                         );

julia> rand(mixed)
Dict{Symbol, Any} with 4 entries:
  :Z => [0.775912, 0.467882]
  :W => :red
  :X => [3, 1, 2]
  :Y => Bool[1, 0, 1]
```
"""
Base.rand(rng::Random.AbstractRNG, se::AbstractSearchSpace) = value(RandomSampler(se;rng=rng))
Base.rand(se::AbstractSearchSpace) = rand(Random.default_rng(), se)
function Base.rand(rng::Random.AbstractRNG, se::AbstractSearchSpace, d::Integer)
    s = RandomSampler(se;rng=rng)
    [value(s) for _ in 1:d]
end

Base.rand(se::AbstractSearchSpace, d::Integer) = rand(Random.default_rng(), se, d)

