# SearchSpaces.jl


[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Just a simple Julia package to define search spaces for, perhaps, optimization.

## Installation

Open Julia (v1.7 or latest) and type the following command:

```
julia> ]add SearchSpaces
```

or 


```julia
julia> import Pkg; Pkg.add("SearchSpaces")
```

## Quick Start

The search space can be composed by other spaces. Here, you can define custom search spaces
as follows:

Assume the following three search spaces: 

```math
\begin{matrix}
X = &\{10, 20, \ldots, 50\}\\
Y = &\{\text{red},\ \text{green},\ \text{blue}\}\\
Z = &\{0, 0.1, 0.2, \ldots, 1\}
\end{matrix}
```

Let us define a mixed space $X \times Y \times Z$. Here, we can proceed as follows:


```@repl index
using SearchSpaces # hide
searchspace = MixedSpace(
                  :X => 10:10:50,
                  :Y => [:red, :green, :blue],
                  :Z => 0:0.1:1
                  )
```

Computing the [`cardinality`](@ref) of the search space:

```@repl index
cardinality(searchspace)
```
This can be useful to know how many items are in the search space.

Now, let's sample some random elements in the mixed space.

```@repl index
rand(searchspace)
```

To sample every element in the search space, we can use the grid sampler:

```@repl index
collect(Grid(searchspace))
```


## Contents

```@contents
Pages = ["examples.md", "api.md"]
Depth = 3
```
