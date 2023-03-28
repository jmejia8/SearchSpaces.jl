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

## Usage

**Bounds**

```julia
using SearchSpaces

# define upper and lower bounds
bounds = Bounds(lb = [-1.0, -1, -1], ub = [2.0, 3, 4])

# Sample a random element in bounds
rand(bounds)
# sample several
rand(bounds, 11)
```

Se [here](https://jmejia8.github.io/SearchSpaces.jl/stable/examples/) for more examples.


## API


Implemented search spaces and method:

- `Bounds{T}`: Defined by bounds for numeric values `T`.
- `Permutations(dim)`: Space containing permutations with dimension `dim`.
- `BitArrays(dim)`: Space containing bit arrays with dimension `dim`.
- `MixedSpace(:space => AtomicSearchSpace...)`: Search spaces composed of other search spaces.
- `cardinality`: to get the cardinality of the search space.
- `AtomicSearchSpace` is an abstract type to define primitive search spaces.

