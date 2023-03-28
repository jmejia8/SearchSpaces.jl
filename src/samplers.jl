abstract type AbstractSampler end
abstract type AbstractRNGSampler end

struct Sampler{M, S} <: AbstractSampler
    method::M
    searchspace::S
    len::Union{Int, BigInt, Float64, BigFloat}
end

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

"""
    AtRandom(searchspace;rng)

Define a random iterator for the search space.
"""
struct AtRandom{R} <: AbstractRNGSampler
    rng::R
end

function AtRandom(searchspace::AbstractSearchSpace; rng=Random.default_rng())
    Sampler(AtRandom(rng), searchspace)
end


"""
    Grid(searchspace; npartitions)

Return an iterator over the given searchspace.

The `npartitions` controls the number of partitions for each axis when `searchspace isa Hyperrectangle` (3 by default).

# Examples

```julia-repl
julia> for x in Grid(PermutationSpace([:red, :green, :blue]))
           @show x
       end
x = [:red, :green, :blue]
x = [:red, :blue, :green]
x = [:green, :red, :blue]
x = [:green, :blue, :red]
x = [:blue, :red, :green]
x = [:blue, :green, :red]

julia> for x in Grid(Hyperrectangle(lb=[-1.0, -1], ub=[1, 0.0]), npartitions=3)
           @show x
       end
x = [-1.0, -1.0]
x = [0.0, -1.0]
x = [1.0, -1.0]
x = [-1.0, -0.5]
x = [0.0, -0.5]
x = [1.0, -0.5]
x = [-1.0, 0.0]
x = [0.0, 0.0]
x = [1.0, 0.0]

julia> mixed = MixedSpace(
                                 :W => CategorySpace([:red, :green, :blue]),
                                 :X => PermutationSpace(2),
                                 :Y => BitArrays(2),
                                );

julia> collect(Grid(mixed))
24-element Vector{Any}:
 Dict{Symbol, Any}(:W => :red, :X => [1, 2], :Y => Bool[0, 0])
 Dict{Symbol, Any}(:W => :green, :X => [1, 2], :Y => Bool[0, 0])
 Dict{Symbol, Any}(:W => :blue, :X => [1, 2], :Y => Bool[0, 0])
 Dict{Symbol, Any}(:W => :red, :X => [2, 1], :Y => Bool[0, 0])
 Dict{Symbol, Any}(:W => :green, :X => [2, 1], :Y => Bool[0, 0])
 Dict{Symbol, Any}(:W => :blue, :X => [2, 1], :Y => Bool[0, 0])
 ⋮
 Dict{Symbol, Any}(:W => :blue, :X => [2, 1], :Y => Bool[0, 1])
 Dict{Symbol, Any}(:W => :red, :X => [1, 2], :Y => Bool[1, 1])
 Dict{Symbol, Any}(:W => :green, :X => [1, 2], :Y => Bool[1, 1])
 Dict{Symbol, Any}(:W => :blue, :X => [1, 2], :Y => Bool[1, 1])
 Dict{Symbol, Any}(:W => :red, :X => [2, 1], :Y => Bool[1, 1])
 Dict{Symbol, Any}(:W => :green, :X => [2, 1], :Y => Bool[1, 1])
 Dict{Symbol, Any}(:W => :blue, :X => [2, 1], :Y => Bool[1, 1])
```
"""
mutable struct Grid <: AbstractSampler
    npartitions::Int
    iterator::Tuple
end


function value(sampler::Sampler{G, S}) where {G<:Grid,S<:AtomicSearchSpace}
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
    if length(val) == 1
        return val[1]
    end
    
    [v for v in val]
end


Base.length(sampler::Sampler{S, B}) where {S<:Grid,B} = sampler.len
Base.size(sampler::Sampler{S, B}) where {S<:Grid,B} = (sampler.len,)
Base.IsInfinite(sampler::Sampler{S, B}) where {S<:AbstractRNGSampler,B} = true

"""
    rand([rng=GLOBAL_RNG], searchspace, [d])

Pick a random element or array of random elements from the search space specified by searchspace.

### Examples

```julia-repl
julia> searchspace = Hyperrectangle(lb=[-10, 1, 100], ub = [10, 2, 1000]);

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
                          :Z => Hyperrectangle(lb = zeros(2), ub = ones(2))
                         );

julia> rand(mixed)
Dict{Symbol, Any} with 4 entries:
  :Z => [0.775912, 0.467882]
  :W => :red
  :X => [3, 1, 2]
  :Y => Bool[1, 0, 1]
```
"""
Base.rand(rng::Random.AbstractRNG, se::AbstractSearchSpace) = value(AtRandom(se;rng=rng))
Base.rand(se::AbstractSearchSpace) = rand(Random.default_rng(), se)
function Base.rand(rng::Random.AbstractRNG, se::AbstractSearchSpace, d::Integer)
    s = AtRandom(se;rng=rng)
    [value(s) for _ in 1:d]
end

Base.rand(se::AbstractSearchSpace, d::Integer) = rand(Random.default_rng(), se, d)

