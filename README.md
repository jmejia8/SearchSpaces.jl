# SearchSpaces.jl


[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Just a simple Julia package to define search spaces for, perhaps, optimization.

## Installation

Open Julia v1.7 and install using the command:

```
julia> ]add SearchSpaces
```

or 


```julia
julia> import Pkg; Pkg.add("SearchSpaces")
```

Please, visit the [documentation](https://jmejia8.github.io/SearchSpaces.jl/stable/).

## Usage

Assume the following three search spaces: 

```math
\begin{matrix}
X = &\{10, 20, \ldots, 50\}\\
Y = &\{\text{red},\ \text{green},\ \text{blue}\}\\
Z = &\{0, 0.1, 0.2, \ldots, 1\}
\end{matrix}
```

Let us define a mixed space $X \times Y \times Z$. Here, we can proceed as follows:


```julia
julia> using SearchSpaces

julia> searchspace = MixedSpace(
                         :X => 10:10:50,
                         :Y => [:red, :green, :blue],
                         :Z => 0:0.1:1
                         );

julia> cardinality(searchspace)
165

julia> rand(searchspace)
Dict{Symbol, Any} with 3 entries:
  :Z => 0.1
  :X => 50
  :Y => :green

julia> collect(Grid(searchspace))
165-element Vector{Any}:
 Dict{Symbol, Any}(:Z => 0.0, :X => 10, :Y => :red)
 Dict{Symbol, Any}(:Z => 0.1, :X => 10, :Y => :red)
 Dict{Symbol, Any}(:Z => 0.2, :X => 10, :Y => :red)
 ⋮
 Dict{Symbol, Any}(:Z => 0.8, :X => 50, :Y => :blue)
 Dict{Symbol, Any}(:Z => 0.9, :X => 50, :Y => :blue)
 Dict{Symbol, Any}(:Z => 1.0, :X => 50, :Y => :blue)
```

See [here](https://jmejia8.github.io/SearchSpaces.jl/stable/examples/) for more examples.


## Search Spaces

Implemented search spaces:

```julia
julia> subtypes(SearchSpaces.AtomicSearchSpace)
4-element Vector{Any}:
 BitArraySpace
 BoxConstrainedSpace
 CombinationSpace
 PermutationSpace
```
And more can be found [here](https://jmejia8.github.io/SearchSpaces.jl/dev/searchspaces/).
