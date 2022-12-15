# Examples

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

