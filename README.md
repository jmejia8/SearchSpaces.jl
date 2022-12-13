# SearchSpaces.jl

Just a simple Julia package to define search spaces for, perhaps, optimization.

## Search Spaces

Implemented search spaces:

- `Bounds{T}`: Defined by bounds for numeric values `T`.
- `Permutations(dim)`: Space containing permutations with dimension `dim`.
- `BitArrays(dim)`: Space containing bit arrays with dimension `dim`.
- `MixedSpace(:space => AtomicSearchSpace...)`: Search spaces composed of other search spaces.

## API

- `cardinality`: to get the cardinality of the search space.
- `AtomicSearchSpace` is an abstract type to define primitive search spaces.
