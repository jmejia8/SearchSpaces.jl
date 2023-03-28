"""
    CategorySpace(categories)

Define a search space given by the provided categories (`Vector`).
"""
function CategorySpace(values::AbstractVector)
    PermutationSpace(values, 1)
end

