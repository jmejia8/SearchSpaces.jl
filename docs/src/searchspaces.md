# Search Spaces

Search spaces are divided in two main types: *Atomic Search Spaces* and *Mixed Spaces*.

Atomic search spaces are those defined by themselves.

```@repl
import InteractiveUtils: subtypes # hide
using SearchSpaces
subtypes(SearchSpaces.AtomicSearchSpace)
```


## Bit Array Space

```@docs
BitArraySpace
```

## Box-Constrained Space (Hyperrectangle)

```@docs
BoxConstrainedSpace
```

## Combination Space

```@docs
CombinationSpace
```

## $k$-Permutation Space

```@docs
PermutationSpace
```

## Category Space

```@docs
CategorySpace
```



## Mixed Space


```@docs
MixedSpace
```


```@docs
×
```
