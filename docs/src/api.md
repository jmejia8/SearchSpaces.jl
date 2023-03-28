# API references

## Search Spaces

The search spaces can be defined as follows.

### $k$-Permutation Space

```@docs
PermutationSpace
```

### CategoricalSpace

```@docs
CategoricalSpace
```

### Bit Arrays


```@docs
BitArraySpace
```

### BoxConstrainedSpace (Box-space)


```julia-repl
BoxConstrainedSpace
```

## Built-in Samplers

```@docs
Grid
```

```@docs
AtRandom
```

## Miscellaneous

```@docs
cardinality
isinbounds
ispermutation
isinspace
Variable
@var
```

```@autodocs
Modules = [SearchSpaces]
```
