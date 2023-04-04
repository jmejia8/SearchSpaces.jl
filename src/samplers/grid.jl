"""
    GridSampler(searchspace; npartitions)

Return an iterator over the given searchspace.

The `npartitions` controls the number of partitions for each axis when `searchspace isa BoxConstrainedSpace` (3 by default).

# Examples

```julia-repl
julia> for x in GridSampler(PermutationSpace([:red, :green, :blue]))
           @show x
       end
x = [:red, :green, :blue]
x = [:red, :blue, :green]
x = [:green, :red, :blue]
x = [:green, :blue, :red]
x = [:blue, :red, :green]
x = [:blue, :green, :red]

julia> for x in GridSampler(BoxConstrainedSpace(lb=[-1.0, -1], ub=[1, 0.0]), npartitions=3)
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

julia> collect(GridSampler(mixed))
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
mutable struct GridSampler <: AbstractSampler
    npartitions::Int
    iterator::Tuple
end


function value(sampler::Sampler{G, S}) where {G<:GridSampler,S<:AtomicSearchSpace}
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


Base.length(sampler::Sampler{S, B}) where {S<:GridSampler,B} = sampler.len
Base.size(sampler::Sampler{S, B}) where {S<:GridSampler,B} = (sampler.len,)

