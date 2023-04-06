# Examples

Some examples on using the package.

## Defining Search Spaces

The available search spaces can be defined using different methods, depending
on the requirements.

### Permutation Space

Firstly, import the package.

```@repl basic
using SearchSpaces
```

Define a search space defined by permuting five positive integers $1,2,\ldots, 5$.

```@repl basic
space = PermutationSpace(5)
rand(space) # sample one random element
```
Permutations of an array of elements:

```@repl basic
space = PermutationSpace([:red, :green, :blue])
rand(space)
```
k-permutation of elements:

```@repl basic
k = 2
space = PermutationSpace([:red, :green, :blue, :alpha], k)
rand(space)
```


### Bit arrays

An array of bits can be defining by providing the number of bits:

```@repl basic
n_bits = 4
space = BitArraySpace(n_bits)
rand(space)
```

### Box-Constrained Space (Hyperrectangle)

A box-constrained space (a.k.a. hyperrectangle) is defined by providing
lower bounds and lower bounds.

Defining a 5-dimensional hyperrectangle with vertices in 0 and 1.

```@repl basic
space = BoxConstrainedSpace(lb = zeros(5), ub = ones(5))
rand(space)
```

A 3-dimensional integer box-constrained space with values between -10 and 10.

```@repl basic
space = BoxConstrainedSpace(lb = fill(-10, 3), ub = fill(10, 3))
rand(space)
```

By default, the lower and upper bounds are rigid, one can specify whether the bounds
are rigid or not.

```@repl basic
space = BoxConstrainedSpace(lb = zeros(2), ub = ones(2), rigid=false)
```

An interval can be defined as:

```@repl basic
my_interval = (-π..π)
rand(my_interval)
```

### Mixed spaces

Mixed space can be compose using Cartesian product.

```@repl basic
space = MixedSpace(:X => PermutationSpace(3), :Y => BitArraySpace(3), :Z => BoxConstrainedSpace(lb = zeros(2), ub = ones(2)))
rand(space)
```


```@repl basic
space = MixedSpace(:x => 1:10, :y => [:red, :green], :z => PermutationSpace(1:3))
rand(space)
```


## Sampling Random Elements

Random elements in a search space can sampled using [`rand`](@ref) method.


```@example random_sample
using SearchSpaces # hide
search_space = PermutationSpace([:red, :green, :blue])
rand(search_space)
```

Sampling ten elements: 

```@example random_sample
rand(search_space, 10)
```

Sampling three elements:

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
for x in GridSampler(search_space)
    @show x
end
```

Similarly:

```@example random_sample
GridSampler(PermutationSpace([:red, :green, :blue])) |> collect
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
argmin(f, GridSampler(searchspace))
```

## Cardinality

The number of elements in a set is known as the [`cardinality`](@ref).
The package includes a method to compute this value:

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
search space. We can use the [`in`](@ref) method:


```@repl basic
space = BoxConstrainedSpace(lb = zeros(3), ub = ones(3))
[0.0, 0, 0] in space
[100.0, 0, 0] in space
[1, 1, 1] in space
```

Note that the last example returned `false` due to the vector of integers is not
in the `space` of floats.

## Solving the 8-Queens problem

This example illustrates how to finding all solutions for the 8-queens problem.

Let's represent a `chessboard` using an 8-permutation. Here, `chessboard[i] = j` means
that there is a queen in the row `i` and  column `j`. The main idea is to find all
chessboard configurations such that the queens are not attacking each other.

```@example basic2
using SearchSpaces

chessboards = PermutationSpace(8)
```

A valid chessboard is obtained when any queen is attacking another queen.
The following function is used to check that:

```@example basic2
function isvalid(chessboard)
   # check attack in both diagonas for each queen
   for i = 1:length(chessboard)
       Δrows = i + chessboard[i]
       Δcols = i - chessboard[i]
       for j = (i+1):length(chessboard)
           # check diagonals
           if  j + chessboard[j] == Δrows || j - chessboard[j] == Δcols
               return false
           end
       end
   end
   true
end
```


Now, let's compute all chessboards (valid or not) by brute force using the grid sampler.

```@example basic2
sampler = GridSampler(chessboards);
nothing # hide
```

Once the sampler is instantiated, we can filter those valid chessboards.

```@example basic2
all_valid_chessboard = filter(isvalid, collect(sampler))
```

Print resulting chessboard:

```@example basic2
function print_chessboard(chessboard)
    println("Chessboard: ", chessboard)
    for i in eachindex(chessboard)
        for j in eachindex(chessboard)
            print(chessboard[i]==j ? "Q " : "_ ")
        end
        println()
    end
end
```

```@example basic2
print_chessboard(first(all_valid_chessboard))
```

```@example basic2
print_chessboard(last(all_valid_chessboard))
```

