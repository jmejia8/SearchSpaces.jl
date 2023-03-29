"""
    CategorySpace(categories)

Define a search space given by the provided categories (`Vector`).

# Example

```julia-repl
julia> space = CategorySpace([:soft, :medium, :high]);

julia> rand(space)
:soft

julia> cardinality(space)
3
```
"""
function CategorySpace(values::AbstractVector)
    PermutationSpace(values, 1)
end

