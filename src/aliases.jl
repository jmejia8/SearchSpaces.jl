const Hyperrectangle = BoxConstrainedSpace


@deprecate Bounds(args...;kargs...)         BoxConstrainedSpace(args...;kargs...)
@deprecate Permutations(args...;kargs...)   PermutationSpace(args...;kargs...)
@deprecate BitArrays(args...;kargs...)      BitArraySpace(args...;kargs...)
@deprecate Categorical(args...;kargs...)    CategorySpace(args...;kargs...)
@deprecate Combinations(args...;kargs...)   CombinationSpace(args...;kargs...)
