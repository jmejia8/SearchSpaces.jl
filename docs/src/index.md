# SearchSpaces.jl


[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Just a simple Julia package to define search spaces for, perhaps, optimization.

## Quick Start

The search space can be composed by other spaces. Here, you can define custom search spaces
as follows:

Assume the following three search spaces: $X = \{10, 20, 30, \ldots, 50\}$,
categorical space $Y = \{\text{red}, \text{green}, \text{blue}\}$, and $Z = \{0, 0.1, 0.2, \ldots, 1\}$.

Let us define a mixed space $X \times Y \times Z$. Here, we can proceed as follows:


```julia-repl
julia> searchspace = MixedSpace(:X=>10:10:50, :Y=>[:red, :green, :blue], :Z =>0:0.1:1);
```

What about the cardinality (size) of the search space:

```julia-repl
julia> cardinality(searchspace)
165
```

This can be useful to know how many items are in the search space.

Now, let's sample some random elements in the mixed space.

```julia-repl
 julia> rand(searchspace)
Dict{Symbol, Any} with 3 entries:
  :color => :green
  :N     => 50
  :p     => 0.6
```

To sample every element in the search space, we can use the grid sampler:

```julia-repl
julia> collect(Grid(searchspace))
165-element Vector{Any}:
 Dict{Symbol, Any}(:color => :red, :N => 10, :p => 0.0)
 Dict{Symbol, Any}(:color => :green, :N => 10, :p => 0.0)
 Dict{Symbol, Any}(:color => :blue, :N => 10, :p => 0.0)
 Dict{Symbol, Any}(:color => :red, :N => 20, :p => 0.0)
 Dict{Symbol, Any}(:color => :green, :N => 20, :p => 0.0)
 Dict{Symbol, Any}(:color => :blue, :N => 20, :p => 0.0)
 Dict{Symbol, Any}(:color => :red, :N => 30, :p => 0.0)
 Dict{Symbol, Any}(:color => :green, :N => 30, :p => 0.0)
 Dict{Symbol, Any}(:color => :blue, :N => 30, :p => 0.0)
 Dict{Symbol, Any}(:color => :red, :N => 40, :p => 0.0)
 ⋮
 Dict{Symbol, Any}(:color => :red, :N => 30, :p => 1.0)
 Dict{Symbol, Any}(:color => :green, :N => 30, :p => 1.0)
 Dict{Symbol, Any}(:color => :blue, :N => 30, :p => 1.0)
 Dict{Symbol, Any}(:color => :red, :N => 40, :p => 1.0)
 Dict{Symbol, Any}(:color => :green, :N => 40, :p => 1.0)
 Dict{Symbol, Any}(:color => :blue, :N => 40, :p => 1.0)
 Dict{Symbol, Any}(:color => :red, :N => 50, :p => 1.0)
 Dict{Symbol, Any}(:color => :green, :N => 50, :p => 1.0)
 Dict{Symbol, Any}(:color => :blue, :N => 50, :p => 1.0)

```


## Search Spaces

Implemented search spaces:

- `Bounds{T}`: Defined by bounds for numeric values `T`.
- `Permutations(dim)`: Space containing permutations with dimension `dim`.
- `BitArrays(dim)`: Space containing bit arrays with dimension `dim`.
- `MixedSpace(:space => AtomicSearchSpace...)`: Search spaces composed of other search spaces.

## API

- `cardinality`: to get the cardinality of the search space.
- `AtomicSearchSpace` is an abstract type to define primitive search spaces.
