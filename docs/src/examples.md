# Examples


## Defining Search Spaces

### Permutation Space

```@repl basic
using SearchSpaces
PermutationSpace(5)
PermutationSpace([:red, :green, :blue])
PermutationSpace([:red, :green, :blue, :alpha], 2)
```


### Bit arrays

```@repl basic
BitArraySpace(4)
```

### Box-Constrained Space (Hyperrectangle)

```@repl basic
BoxConstrainedSpace(lb = 1.1, ub = 4.1)
BoxConstrainedSpace(lb = zeros(5), ub = ones(5))
BoxConstrainedSpace(lb = fill(-10, 3), ub = fill(10, 3))
BoxConstrainedSpace(lb = zeros(2), ub = ones(2), rigid=false)
```

An interval can be defined as:


```@repl basic
my_interval = (-π..π)
```

### Mixed spaces

```@repl basic
MixedSpace(:X => PermutationSpace(3), :Y => BitArraySpace(3), :Z => BoxConstrainedSpace(lb = zeros(2), ub = ones(2)))
MixedSpace(:x => 1:10, :y => [:red, :green], :z => PermutationSpace(1:3))
```


## Sampling Random Elements

Random elements in a search space can sampled using [`rand`](@ref) method.


```@example random_sample
using SearchSpaces # hide
search_space = PermutationSpace([:red, :green, :blue])
rand(search_space)
```

```@example random_sample
rand(search_space, 10)
```


```@example random_sample
mixed = MixedSpace(:x => 1:10, :y => [:red, :green], :z => PermutationSpace(1:3))
rand(mixed, 3)
```


## Sampling All Elements

!!! warning
    Sampling and collecting all elements in search space can overflow memory.

Implemented samplers return an iterator to avoid memory overflow.

```@example random_sample
search_space = PermutationSpace([:red, :green, :blue])
for x in Grid(search_space)
    @show x
end
```

Similarly:

```@example random_sample
Grid(PermutationSpace([:red, :green, :blue])) |> collect
```

## Mixing Spaces

We can mix spaces via [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product).

```@example random_sample
bounds = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5))
permutations = PermutationSpace([:red, :green, :blue])
bits = BitArraySpace(3)
```

Performing Cartesian product:

```@example random_sample
mixed = bounds × permutations × bits
```

Sampling a random element:

```@example random_sample
rand(mixed)
```

Cardinality (number of elements)


```@example random_sample
cardinality(mixed)
```


## Finding Elements

A search space is only a place where certain items are. However, those elements appear
under the presence of a sampler. Let's find the argument that minimizes function.

Finding the argument that minimizes a given function.

```@repl basic
searchspace = MixedSpace(
                    :N    => 1:50,
                    :flag => [true, false],
                    :p    => BoxConstrainedSpace(0.0, 1)
                    );
f(x) = x[:flag] ? sum(1:x[:N])-x[:p] : x[:p] + sum(1:x[:N])
argmin(f, Grid(searchspace))
```

## Cardinality

The number of elements in a set is known as the [`cardinality`](@ref).
The package include a method to compute this value:

The number of permutation strings of size 3:

```@repl basic
space = PermutationSpace([:red, :green, :blue])
cardinality(space)
```

The number of bit arrays of size 10:

```@repl basic
space = BitArraySpace(10)
cardinality(space)
```

Number of 5-dimensional arrays of integers:

```@repl basic
space = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5))
cardinality(space)
```

Number of 5-dimensional arrays of Floats:

```@repl basic
space = BoxConstrainedSpace(lb = zeros(5), ub = ones(5))
cardinality(space)
```

## Is an element in the search space?


Once a search space is defined, maybe we would like to know whether an element is in the
search space. We can use the `in` method:


```@repl basic
space = BoxConstrainedSpace(lb = zeros(3), ub = ones(3))
[0.0, 0, 0] in space
[100.0, 0, 0] in space
[1, 1, 1] in space
```

Note that the last example returned `false` due to the vector of integers is not
in the `space` of floats.
