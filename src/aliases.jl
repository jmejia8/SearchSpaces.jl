const BoundingBoxSpace = Hyperrectangle


@deprecate Bounds(args...;kargs...) Hyperrectangle(args...;kargs...)
@deprecate Permutations(args...;kargs...) PermutationSpace(args...;kargs...)
@deprecate BitArrays(args...;kargs...)    BitArraySpace(args...;kargs...)
@deprecate Categorical(args...;kargs...)  CategorySpace(args...;kargs...)
@deprecate Combinations(args...;kargs...) CombinationSpace(args...;kargs...)
