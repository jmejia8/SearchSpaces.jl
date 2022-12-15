"""
    Categorical(categories)

Define a search space given by the provided categories (`Vector`).
"""
function Categorical(values::AbstractVector)
    Permutations(values, 1)
end
