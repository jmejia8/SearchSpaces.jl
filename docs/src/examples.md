# Examples

## Finding Elements

A search space is only a place where certain items are. However, those elements appear
under the presence of a sampler. Let's find the argument that minimizes function.

Finding the argument that minimizes a given function.

```@repl basic
using SearchSpaces
searchspace = MixedSpace(:N=>1:50, :flag => [true, false], :p =>Bounds(0.0, 1));
f(x) = x[:flag] ? sum(1:x[:N])-x[:p] : x[:p] + sum(1:x[:N])
argmin(f, Grid(searchspace))
```

## Defining Search Spaces

### Permutations

```@repl basic
Permutations(5)
Permutations([:red, :green, :blue])
Permutations([:red, :green, :blue, :alpha], 2)
```


### Bit arrays

```@repl basic
BitArrays(4)
```

### Bounds

```@repl basic
Bounds(lb = 1.1, ub = 4.1)
Bounds(lb = zeros(5), ub = ones(5))
Bounds(lb = fill(-10, 3), ub = fill(10, 3))
Bounds(lb = zeros(2), ub = ones(2), rigid=false)
```

### Mixed spaces

```@repl basic
MixedSpace(:X => Permutations(3), :Y => BitArrays(3), :Z => Bounds(lb = zeros(2), ub = ones(2)))
MixedSpace(:x => 1:10, :y => [:red, :green], :z => Permutations(1:3))
```


## Sampling Random Elements

Random elements in a search space can sampled using [`rand`](@ref) method.


```@example random_sample
using SearchSpaces # hide
search_space = Permutations([:red, :green, :blue])
rand(search_space)
```

```@example random_sample
rand(search_space, 10)
```


```@example random_sample
mixed = MixedSpace(:x => 1:10, :y => [:red, :green], :z => Permutations(1:3))
rand(mixed, 3)
```


## Sampling All Elements

!!! warning
    Sampling and collecting all elements in search space can overflow memory.

Implemented samplers return an iterator to avoid memory overflow.

```@example random_sample
search_space = Permutations([:red, :green, :blue])
for x in Grid(search_space)
    @show x
end
```

Similarly:

```@example random_sample
Grid(Permutations([:red, :green, :blue])) |> collect
```

## Mixing Spaces

We can mix spaces via [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product).

```@example random_sample
bounds = Bounds(lb = zeros(Int, 5), ub = ones(Int, 5))
permutations = Permutations([:red, :green, :blue])
bits = BitArrays(3)
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

## Cardinality

The number of elements in a set is known as the [`cardinality`](@ref).
The package include a method to compute this value:

The number of permutation strings of size 3:

```@repl basic
space = Permutations([:red, :green, :blue])
cardinality(space)
```

The number of bit arrays of size 10:

```@repl basic
space = BitArrays(10)
cardinality(space)
```

Number of 5-dimensional arrays of integers:

```@repl basic
space = Bounds(lb = zeros(Int, 5), ub = ones(Int, 5))
cardinality(space)
```

Number of 5-dimensional arrays of Floats:

```@repl basic
space = Bounds(lb = zeros(5), ub = ones(5))
cardinality(space)
```

## Is an element in the search space?


Once a search space is defined, maybe we would like to know whether an element is in the
search space. We can use the `in` method:


```@repl basic
space = Bounds(lb = zeros(3), ub = ones(3))
[0.0, 0, 0] in space
[100.0, 0, 0] in space
[1, 1, 1] in space
```

Note that the last example returned `false` due to the vector of integers is not
in the `space` of floats.