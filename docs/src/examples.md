# Examples

# Finding Elements

A search space is only a place where certain items are. However, those elements appear
under the presence of a sampler. Let's find the argument that minimizes function.

Finding the argument that minimizes a given function.

```julia-repl
julia> searchspace = MixedSpace(:N=>1:50, :flag => [true, false], :p =>Bounds(0.0, 1));

julia> f(x) = x[:flag] ? sum(1:x[:N])-x[:p] : x[:p] + sum(1:x[:N])
f (generic function with 3 methods)

julia> argmin(f, Grid(searchspace))
Dict{Symbol, Real} with 3 entries:
  :N    => 1
  :p    => 1.0
  :flag => true
```

## Defining Search Spaces

```julia-repl
Permutations(5)
Permutations([:red, :green, :blue])
Permutations([:red, :green, :blue, :alpha], 2)
```

```julia-repl
BitArrays(4)
```

```julia-repl
Bounds(lb = 1.1, ub = 4.1)
Bounds(lb = zeros(5), ub = ones(5))
Bounds(lb = fill(-10, 3), ub = fill(10, 3))
Bounds(lb = zeros(2), ub = ones(2), rigid=false)
```

```julia-repl
MixedSpace(:X => Permutations(3), :Y => BitArrays(3), :Z => Bounds(lb = zeros(2), ub = ones(2)))
MixedSpace(:x => 1:10, :y => [:red, :green], :z => Permutations(1:3))
```

