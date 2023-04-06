var documenterSearchIndex = {"docs":
[{"location":"api/#API-references","page":"API References","title":"API references","text":"","category":"section"},{"location":"api/#Built-in-Samplers","page":"API References","title":"Built-in Samplers","text":"","category":"section"},{"location":"api/","page":"API References","title":"API References","text":"Grid","category":"page"},{"location":"api/#SearchSpaces.Grid","page":"API References","title":"SearchSpaces.Grid","text":"Grid(searchspace; npartitions)\n\nReturn an iterator over the given searchspace.\n\nThe npartitions controls the number of partitions for each axis when searchspace isa BoxConstrainedSpace (3 by default).\n\nExamples\n\njulia> for x in Grid(PermutationSpace([:red, :green, :blue]))\n           @show x\n       end\nx = [:red, :green, :blue]\nx = [:red, :blue, :green]\nx = [:green, :red, :blue]\nx = [:green, :blue, :red]\nx = [:blue, :red, :green]\nx = [:blue, :green, :red]\n\njulia> for x in Grid(BoxConstrainedSpace(lb=[-1.0, -1], ub=[1, 0.0]), npartitions=3)\n           @show x\n       end\nx = [-1.0, -1.0]\nx = [0.0, -1.0]\nx = [1.0, -1.0]\nx = [-1.0, -0.5]\nx = [0.0, -0.5]\nx = [1.0, -0.5]\nx = [-1.0, 0.0]\nx = [0.0, 0.0]\nx = [1.0, 0.0]\n\njulia> mixed = MixedSpace(\n                                 :W => CategorySpace([:red, :green, :blue]),\n                                 :X => PermutationSpace(2),\n                                 :Y => BitArrays(2),\n                                );\n\njulia> collect(Grid(mixed))\n24-element Vector{Any}:\n Dict{Symbol, Any}(:W => :red, :X => [1, 2], :Y => Bool[0, 0])\n Dict{Symbol, Any}(:W => :green, :X => [1, 2], :Y => Bool[0, 0])\n Dict{Symbol, Any}(:W => :blue, :X => [1, 2], :Y => Bool[0, 0])\n Dict{Symbol, Any}(:W => :red, :X => [2, 1], :Y => Bool[0, 0])\n Dict{Symbol, Any}(:W => :green, :X => [2, 1], :Y => Bool[0, 0])\n Dict{Symbol, Any}(:W => :blue, :X => [2, 1], :Y => Bool[0, 0])\n ⋮\n Dict{Symbol, Any}(:W => :blue, :X => [2, 1], :Y => Bool[0, 1])\n Dict{Symbol, Any}(:W => :red, :X => [1, 2], :Y => Bool[1, 1])\n Dict{Symbol, Any}(:W => :green, :X => [1, 2], :Y => Bool[1, 1])\n Dict{Symbol, Any}(:W => :blue, :X => [1, 2], :Y => Bool[1, 1])\n Dict{Symbol, Any}(:W => :red, :X => [2, 1], :Y => Bool[1, 1])\n Dict{Symbol, Any}(:W => :green, :X => [2, 1], :Y => Bool[1, 1])\n Dict{Symbol, Any}(:W => :blue, :X => [2, 1], :Y => Bool[1, 1])\n\n\n\n\n\n","category":"type"},{"location":"api/","page":"API References","title":"API References","text":"AtRandom","category":"page"},{"location":"api/#SearchSpaces.AtRandom","page":"API References","title":"SearchSpaces.AtRandom","text":"AtRandom(searchspace;rng)\n\nDefine a random iterator for the search space.\n\n\n\n\n\n","category":"type"},{"location":"api/#Miscellaneous","page":"API References","title":"Miscellaneous","text":"","category":"section"},{"location":"api/","page":"API References","title":"API References","text":"cardinality\nisinbounds\nispermutation\nisinspace\nVariable\n@var","category":"page"},{"location":"api/#SearchSpaces.cardinality","page":"API References","title":"SearchSpaces.cardinality","text":"cardinality(searchspace)\n\nCardinality of the search space.\n\nExample\n\njulia> cardinality(PermutationSpace(5))\n120\n\njulia> cardinality(BoxConstrainedSpace(lb = zeros(2), ub = ones(2)))\nInf\n\njulia> cardinality(BoxConstrainedSpace(lb = zeros(Int, 2), ub = ones(Int,2)))\n4\n\njulia> mixed = MixedSpace(\n                          :W => CategorySpace([:red, :green, :blue]),\n                          :X => PermutationSpace(3),\n                          :Y => BitArraySpace(3),\n                         );\n\njulia> cardinality(mixed)\n144\n\n\n\n\n\n","category":"function"},{"location":"api/#SearchSpaces.isinbounds","page":"API References","title":"SearchSpaces.isinbounds","text":"isinbounds(item, searchspace) --> Bool\n\nDetermine whether an item is in the given searchspace.\n\n\n\n\n\n","category":"function"},{"location":"api/#SearchSpaces.ispermutation","page":"API References","title":"SearchSpaces.ispermutation","text":"ispermutation(item, searchspace) --> Bool\n\nDetermine whether an item is in the given searchspace.\n\n\n\n\n\n","category":"function"},{"location":"api/#SearchSpaces.isinspace","page":"API References","title":"SearchSpaces.isinspace","text":"isinspace(item, searchspace) --> Bool\n\nDetermine whether an item is in the given searchspace.\n\nSee also in.\n\n\n\n\n\n","category":"function"},{"location":"api/#SearchSpaces.Variable","page":"API References","title":"SearchSpaces.Variable","text":"Variable(name, searchspace)\n\nA structure to define a variable in the search space: searchspace.\n\n\n\n\n\n","category":"type"},{"location":"api/#SearchSpaces.@var","page":"API References","title":"SearchSpaces.@var","text":"@var x in searchspace\n\nA macro to define a Variable for in the given search space.\n\n\n\n\n\n","category":"macro"},{"location":"api/","page":"API References","title":"API References","text":"Modules = [SearchSpaces]","category":"page"},{"location":"api/#SearchSpaces.BitArraySpace-Tuple{}","page":"API References","title":"SearchSpaces.BitArraySpace","text":"BitArraySpace(;dim)\n\nDefine a search space delimited by bit arrays.\n\nExample\n\njulia> space = BitArraySpace(4)\nBitArraySpace(4)\n\njulia> rand(space, 7)\n7-element Vector{Vector{Bool}}:\n [0, 1, 1, 0]\n [0, 0, 0, 1]\n [1, 1, 1, 0]\n [0, 0, 0, 1]\n [0, 1, 0, 1]\n [1, 1, 1, 0]\n [1, 0, 0, 0]\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.BoxConstrainedSpace-Tuple{AbstractVector, AbstractVector}","page":"API References","title":"SearchSpaces.BoxConstrainedSpace","text":"BoxConstrainedSpace(;lb, ub, rigid=true)\n\nDefine a search space delimited by box constraints.\n\nExample\n\njulia> space = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5))\nBoxConstrainedSpace{Int64}([0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], 5, true)\n\njulia> cardinality(space)\n32\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.CombinationSpace-Tuple{AbstractVector}","page":"API References","title":"SearchSpaces.CombinationSpace","text":"CombinationSpace(values; k)\nCombinationSpace(k)\n\nDefine a search space defined by the combinations (with replacement) of size k.\n\nExample\n\njulia> space = CombinationSpace(3)\nCombinationSpace{UnitRange{Int64}}(1:3, 3)\n\njulia> rand(space)\n3-element Vector{Int64}:\n 1\n 1\n 2\n\njulia> rand(space,7)\n7-element Vector{Vector{Int64}}:\n [1, 1, 1]\n [2, 1, 1]\n [2, 2, 1]\n [2, 3, 3]\n [1, 3, 1]\n [2, 1, 2]\n [2, 3, 1]\n\njulia> rand(CombinationSpace([:apple, :orange, :onion, :garlic]))\n4-element Vector{Symbol}:\n :apple\n :orange\n :orange\n :apple\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.MixedSpace-Tuple{Vararg{Pair}}","page":"API References","title":"SearchSpaces.MixedSpace","text":"MixedSpace([itr])\n\nConstruct a search space.\n\nExample\n\njulia> space = MixedSpace( :X => BoxConstrainedSpace(lb = [-1.0, -3.0], ub = [10.0, 10.0]),\n                          :Y => PermutationSpace(10),\n                          :Z => BitArraySpace(dim = 10)\n                          ) \nMixedSpace defined by 3 subspaces:\nX => BoxConstrainedSpace{Float64}([-1.0, -3.0], [10.0, 10.0], [11.0, 13.0], 2, true)\nY => PermutationSpace{Vector{Int64}}([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10)\nZ => BitArraySpace(10)\n\n\njulia> rand(space)\nDict{Symbol, Vector} with 3 entries:\n  :Z => Bool[0, 1, 0, 0, 0, 0, 0, 1, 1, 0]\n  :X => [0.367973, 4.62101]\n  :Y => [4, 3, 9, 1, 7, 2, 10, 8, 5, 6]\n\nSee also ×\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.PermutationSpace-Tuple{AbstractVector}","page":"API References","title":"SearchSpaces.PermutationSpace","text":"PermutationSpace(values; k)\nPermutationSpace(k)\n\nDefine a search space defined by permuting the values of size k (k-permutations).\n\njulia> space = PermutationSpace([:red, :green, :blue])\nPermutationSpace{Vector{Symbol}}([:red, :green, :blue], 3)\n\njulia> rand(space, 5)\n5-element Vector{Vector{Symbol}}:\n [:blue, :green, :red]\n [:red, :blue, :green]\n [:blue, :green, :red]\n [:green, :blue, :red]\n [:red, :blue, :green]\n\njulia> Grid(PermutationSpace(3)) |> collect\n6-element Vector{Any}:\n [1, 2, 3]\n [1, 3, 2]\n [2, 1, 3]\n [2, 3, 1]\n [3, 1, 2]\n [3, 2, 1]\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.Sampler-Tuple{Any, SearchSpaces.AtomicSearchSpace}","page":"API References","title":"SearchSpaces.Sampler","text":"Sampler(sampler, searchspace)\n\nCrate an iterator for the sampler for the given searchspace.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.in-Tuple{Any, SearchSpaces.AbstractSearchSpace}","page":"API References","title":"Base.in","text":"in(item, searchspace) -> Bool\n\nDetermine whether an item is in the given searchspace.\n\n\n\n\n\n","category":"method"},{"location":"api/#Base.rand-Tuple{Random.AbstractRNG, SearchSpaces.AbstractSearchSpace}","page":"API References","title":"Base.rand","text":"rand([rng=GLOBAL_RNG], searchspace, [d])\n\nPick a random element or array of random elements from the search space specified by searchspace.\n\nExamples\n\njulia> searchspace = BoxConstrainedSpace(lb=[-10, 1, 100], ub = [10, 2, 1000]);\n\njulia> rand(searchspace)\n3-element Vector{Int64}:\n   1\n   1\n 606\n\njulia> rand(searchspace, 3)\n3-element Vector{Vector{Int64}}:\n [0, 1, 440]\n [9, 1, 897]\n [3, 2, 498]\n\nAnother example using MixedSpace:\n\njulia> mixed = MixedSpace(\n                          :W => CategorySpace([:red, :green, :blue]),\n                          :X => PermutationSpace(3),\n                          :Y => BitArrays(3),\n                          :Z => BoxConstrainedSpace(lb = zeros(2), ub = ones(2))\n                         );\n\njulia> rand(mixed)\nDict{Symbol, Any} with 4 entries:\n  :Z => [0.775912, 0.467882]\n  :W => :red\n  :X => [3, 1, 2]\n  :Y => Bool[1, 0, 1]\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.:..-Tuple{Real, Real}","page":"API References","title":"SearchSpaces.:..","text":"..(a, b)\n\nDefine a interval between a and b (inclusive).\n\nExample\n\njulia> my_interval = (-π..π)\n\njulia> rand(my_interval, 5)\n5-element Vector{Float64}:\n 0.5111482297554093\n 1.1984728844571544\n 1.3279941255812906\n 2.3429444282250502\n 3.0495310142685526\n\nSee also BoxConstrainedSpace\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.:×-Union{Tuple{T2}, Tuple{T}, Tuple{T, T2}} where {T<:SearchSpaces.AtomicSearchSpace, T2<:SearchSpaces.AtomicSearchSpace}","page":"API References","title":"SearchSpaces.:×","text":"A × B\n\nReturn the mixed space using Cartesian product.\n\nExample\n\njulia> bounds = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5));\n\njulia> permutations = PermutationSpace([:red, :green, :blue]);\n\njulia> bits = BitArraySpace(3);\n\njulia> mixed = bounds × permutations × bits\nMixedSpace defined by 3 subspaces:\nS3 => BitArraySpace(3)\nS2 => PermutationSpace{Vector{Symbol}}([:red, :green, :blue], 3)\nS1 => BoxConstrainedSpace{Int64}([0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], 5, true)\n\njulia> cardinality(mixed)\n1536\n\njulia> rand(mixed)\nDict{Symbol, Vector} with 3 entries:\n  :S2 => [:red, :blue, :green]\n  :S1 => [0, 1, 0, 0, 1]\n  :S3 => Bool[1, 1, 0]\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.CategorySpace-Tuple{AbstractVector}","page":"API References","title":"SearchSpaces.CategorySpace","text":"CategorySpace(categories)\n\nDefine a search space given by the provided categories (Vector).\n\nExample\n\njulia> space = CategorySpace([:soft, :medium, :high]);\n\njulia> rand(space)\n:soft\n\njulia> cardinality(space)\n3\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.cardinality-Tuple{BitArraySpace}","page":"API References","title":"SearchSpaces.cardinality","text":"cardinality(searchspace)\n\nCardinality of the search space.\n\nExample\n\njulia> cardinality(PermutationSpace(5))\n120\n\njulia> cardinality(BoxConstrainedSpace(lb = zeros(2), ub = ones(2)))\nInf\n\njulia> cardinality(BoxConstrainedSpace(lb = zeros(Int, 2), ub = ones(Int,2)))\n4\n\njulia> mixed = MixedSpace(\n                          :W => CategorySpace([:red, :green, :blue]),\n                          :X => PermutationSpace(3),\n                          :Y => BitArraySpace(3),\n                         );\n\njulia> cardinality(mixed)\n144\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.isinbounds-Tuple{Any, BoxConstrainedSpace}","page":"API References","title":"SearchSpaces.isinbounds","text":"isinbounds(item, searchspace) --> Bool\n\nDetermine whether an item is in the given searchspace.\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.isinspace-Tuple{Any, PermutationSpace}","page":"API References","title":"SearchSpaces.isinspace","text":"isinspace(item, searchspace) --> Bool\n\nDetermine whether an item is in the given searchspace.\n\nSee also in.\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.ispermutation-Tuple{Any, PermutationSpace}","page":"API References","title":"SearchSpaces.ispermutation","text":"ispermutation(item, searchspace) --> Bool\n\nDetermine whether an item is in the given searchspace.\n\n\n\n\n\n","category":"method"},{"location":"api/#SearchSpaces.@var-Tuple{Any}","page":"API References","title":"SearchSpaces.@var","text":"@var x in searchspace\n\nA macro to define a Variable for in the given search space.\n\n\n\n\n\n","category":"macro"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/#Defining-Search-Spaces","page":"Examples","title":"Defining Search Spaces","text":"","category":"section"},{"location":"examples/#Permutation-Space","page":"Examples","title":"Permutation Space","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"using SearchSpaces\nPermutationSpace(5)\nPermutationSpace([:red, :green, :blue])\nPermutationSpace([:red, :green, :blue, :alpha], 2)","category":"page"},{"location":"examples/#Bit-arrays","page":"Examples","title":"Bit arrays","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"BitArraySpace(4)","category":"page"},{"location":"examples/#Box-Constrained-Space-(Hyperrectangle)","page":"Examples","title":"Box-Constrained Space (Hyperrectangle)","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"BoxConstrainedSpace(lb = 1.1, ub = 4.1)\nBoxConstrainedSpace(lb = zeros(5), ub = ones(5))\nBoxConstrainedSpace(lb = fill(-10, 3), ub = fill(10, 3))\nBoxConstrainedSpace(lb = zeros(2), ub = ones(2), rigid=false)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"An interval can be defined as:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"my_interval = (-π..π)","category":"page"},{"location":"examples/#Mixed-spaces","page":"Examples","title":"Mixed spaces","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"MixedSpace(:X => PermutationSpace(3), :Y => BitArraySpace(3), :Z => BoxConstrainedSpace(lb = zeros(2), ub = ones(2)))\nMixedSpace(:x => 1:10, :y => [:red, :green], :z => PermutationSpace(1:3))","category":"page"},{"location":"examples/#Sampling-Random-Elements","page":"Examples","title":"Sampling Random Elements","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Random elements in a search space can sampled using rand method.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using SearchSpaces # hide\nsearch_space = PermutationSpace([:red, :green, :blue])\nrand(search_space)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"rand(search_space, 10)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"mixed = MixedSpace(:x => 1:10, :y => [:red, :green], :z => PermutationSpace(1:3))\nrand(mixed, 3)","category":"page"},{"location":"examples/#Sampling-All-Elements","page":"Examples","title":"Sampling All Elements","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"warning: Warning\nSampling and collecting all elements in search space can overflow memory.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Implemented samplers return an iterator to avoid memory overflow.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"search_space = PermutationSpace([:red, :green, :blue])\nfor x in Grid(search_space)\n    @show x\nend","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Similarly:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Grid(PermutationSpace([:red, :green, :blue])) |> collect","category":"page"},{"location":"examples/#Mixing-Spaces","page":"Examples","title":"Mixing Spaces","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"We can mix spaces via Cartesian product.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"bounds = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5))\npermutations = PermutationSpace([:red, :green, :blue])\nbits = BitArraySpace(3)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Performing Cartesian product:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"mixed = bounds × permutations × bits","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Sampling a random element:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"rand(mixed)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Cardinality (number of elements)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"cardinality(mixed)","category":"page"},{"location":"examples/#Finding-Elements","page":"Examples","title":"Finding Elements","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"A search space is only a place where certain items are. However, those elements appear under the presence of a sampler. Let's find the argument that minimizes function.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Finding the argument that minimizes a given function.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"searchspace = MixedSpace(\n                    :N    => 1:50,\n                    :flag => [true, false],\n                    :p    => BoxConstrainedSpace(0.0, 1)\n                    );\nf(x) = x[:flag] ? sum(1:x[:N])-x[:p] : x[:p] + sum(1:x[:N])\nargmin(f, Grid(searchspace))","category":"page"},{"location":"examples/#Cardinality","page":"Examples","title":"Cardinality","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"The number of elements in a set is known as the cardinality. The package include a method to compute this value:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"The number of permutation strings of size 3:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"space = PermutationSpace([:red, :green, :blue])\ncardinality(space)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"The number of bit arrays of size 10:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"space = BitArraySpace(10)\ncardinality(space)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Number of 5-dimensional arrays of integers:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"space = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5))\ncardinality(space)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Number of 5-dimensional arrays of Floats:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"space = BoxConstrainedSpace(lb = zeros(5), ub = ones(5))\ncardinality(space)","category":"page"},{"location":"examples/#Is-an-element-in-the-search-space?","page":"Examples","title":"Is an element in the search space?","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Once a search space is defined, maybe we would like to know whether an element is in the search space. We can use the in method:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"space = BoxConstrainedSpace(lb = zeros(3), ub = ones(3))\n[0.0, 0, 0] in space\n[100.0, 0, 0] in space\n[1, 1, 1] in space","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Note that the last example returned false due to the vector of integers is not in the space of floats.","category":"page"},{"location":"searchspaces/#Search-Spaces","page":"Search Spaces","title":"Search Spaces","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"Search spaces are divided in two main types: Atomic Search Spaces and Mixed Spaces.","category":"page"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"Atomic search spaces are those defined by themselves.","category":"page"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"import InteractiveUtils: subtypes # hide\nusing SearchSpaces\nsubtypes(SearchSpaces.AtomicSearchSpace)","category":"page"},{"location":"searchspaces/#Bit-Array-Space","page":"Search Spaces","title":"Bit Array Space","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"BitArraySpace","category":"page"},{"location":"searchspaces/#SearchSpaces.BitArraySpace","page":"Search Spaces","title":"SearchSpaces.BitArraySpace","text":"BitArraySpace(;dim)\n\nDefine a search space delimited by bit arrays.\n\nExample\n\njulia> space = BitArraySpace(4)\nBitArraySpace(4)\n\njulia> rand(space, 7)\n7-element Vector{Vector{Bool}}:\n [0, 1, 1, 0]\n [0, 0, 0, 1]\n [1, 1, 1, 0]\n [0, 0, 0, 1]\n [0, 1, 0, 1]\n [1, 1, 1, 0]\n [1, 0, 0, 0]\n\n\n\n\n\n","category":"type"},{"location":"searchspaces/#Box-Constrained-Space-(Hyperrectangle)","page":"Search Spaces","title":"Box-Constrained Space (Hyperrectangle)","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"BoxConstrainedSpace","category":"page"},{"location":"searchspaces/#SearchSpaces.BoxConstrainedSpace","page":"Search Spaces","title":"SearchSpaces.BoxConstrainedSpace","text":"BoxConstrainedSpace(;lb, ub, rigid=true)\n\nDefine a search space delimited by box constraints.\n\nExample\n\njulia> space = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5))\nBoxConstrainedSpace{Int64}([0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], 5, true)\n\njulia> cardinality(space)\n32\n\n\n\n\n\n","category":"type"},{"location":"searchspaces/#Combination-Space","page":"Search Spaces","title":"Combination Space","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"CombinationSpace","category":"page"},{"location":"searchspaces/#SearchSpaces.CombinationSpace","page":"Search Spaces","title":"SearchSpaces.CombinationSpace","text":"CombinationSpace(values; k)\nCombinationSpace(k)\n\nDefine a search space defined by the combinations (with replacement) of size k.\n\nExample\n\njulia> space = CombinationSpace(3)\nCombinationSpace{UnitRange{Int64}}(1:3, 3)\n\njulia> rand(space)\n3-element Vector{Int64}:\n 1\n 1\n 2\n\njulia> rand(space,7)\n7-element Vector{Vector{Int64}}:\n [1, 1, 1]\n [2, 1, 1]\n [2, 2, 1]\n [2, 3, 3]\n [1, 3, 1]\n [2, 1, 2]\n [2, 3, 1]\n\njulia> rand(CombinationSpace([:apple, :orange, :onion, :garlic]))\n4-element Vector{Symbol}:\n :apple\n :orange\n :orange\n :apple\n\n\n\n\n\n","category":"type"},{"location":"searchspaces/#k-Permutation-Space","page":"Search Spaces","title":"k-Permutation Space","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"PermutationSpace","category":"page"},{"location":"searchspaces/#SearchSpaces.PermutationSpace","page":"Search Spaces","title":"SearchSpaces.PermutationSpace","text":"PermutationSpace(values; k)\nPermutationSpace(k)\n\nDefine a search space defined by permuting the values of size k (k-permutations).\n\njulia> space = PermutationSpace([:red, :green, :blue])\nPermutationSpace{Vector{Symbol}}([:red, :green, :blue], 3)\n\njulia> rand(space, 5)\n5-element Vector{Vector{Symbol}}:\n [:blue, :green, :red]\n [:red, :blue, :green]\n [:blue, :green, :red]\n [:green, :blue, :red]\n [:red, :blue, :green]\n\njulia> Grid(PermutationSpace(3)) |> collect\n6-element Vector{Any}:\n [1, 2, 3]\n [1, 3, 2]\n [2, 1, 3]\n [2, 3, 1]\n [3, 1, 2]\n [3, 2, 1]\n\n\n\n\n\n","category":"type"},{"location":"searchspaces/#Category-Space","page":"Search Spaces","title":"Category Space","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"CategorySpace","category":"page"},{"location":"searchspaces/#SearchSpaces.CategorySpace","page":"Search Spaces","title":"SearchSpaces.CategorySpace","text":"CategorySpace(categories)\n\nDefine a search space given by the provided categories (Vector).\n\nExample\n\njulia> space = CategorySpace([:soft, :medium, :high]);\n\njulia> rand(space)\n:soft\n\njulia> cardinality(space)\n3\n\n\n\n\n\n","category":"function"},{"location":"searchspaces/#Mixed-Space","page":"Search Spaces","title":"Mixed Space","text":"","category":"section"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"MixedSpace","category":"page"},{"location":"searchspaces/#SearchSpaces.MixedSpace","page":"Search Spaces","title":"SearchSpaces.MixedSpace","text":"MixedSpace([itr])\n\nConstruct a search space.\n\nExample\n\njulia> space = MixedSpace( :X => BoxConstrainedSpace(lb = [-1.0, -3.0], ub = [10.0, 10.0]),\n                          :Y => PermutationSpace(10),\n                          :Z => BitArraySpace(dim = 10)\n                          ) \nMixedSpace defined by 3 subspaces:\nX => BoxConstrainedSpace{Float64}([-1.0, -3.0], [10.0, 10.0], [11.0, 13.0], 2, true)\nY => PermutationSpace{Vector{Int64}}([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 10)\nZ => BitArraySpace(10)\n\n\njulia> rand(space)\nDict{Symbol, Vector} with 3 entries:\n  :Z => Bool[0, 1, 0, 0, 0, 0, 0, 1, 1, 0]\n  :X => [0.367973, 4.62101]\n  :Y => [4, 3, 9, 1, 7, 2, 10, 8, 5, 6]\n\nSee also ×\n\n\n\n\n\n","category":"type"},{"location":"searchspaces/","page":"Search Spaces","title":"Search Spaces","text":"×","category":"page"},{"location":"searchspaces/#SearchSpaces.:×","page":"Search Spaces","title":"SearchSpaces.:×","text":"A × B\n\nReturn the mixed space using Cartesian product.\n\nExample\n\njulia> bounds = BoxConstrainedSpace(lb = zeros(Int, 5), ub = ones(Int, 5));\n\njulia> permutations = PermutationSpace([:red, :green, :blue]);\n\njulia> bits = BitArraySpace(3);\n\njulia> mixed = bounds × permutations × bits\nMixedSpace defined by 3 subspaces:\nS3 => BitArraySpace(3)\nS2 => PermutationSpace{Vector{Symbol}}([:red, :green, :blue], 3)\nS1 => BoxConstrainedSpace{Int64}([0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], 5, true)\n\njulia> cardinality(mixed)\n1536\n\njulia> rand(mixed)\nDict{Symbol, Vector} with 3 entries:\n  :S2 => [:red, :blue, :green]\n  :S1 => [0, 1, 0, 0, 1]\n  :S3 => Bool[1, 1, 0]\n\n\n\n\n\n","category":"function"},{"location":"#SearchSpaces.jl","page":"Index","title":"SearchSpaces.jl","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"(Image: Aqua QA)","category":"page"},{"location":"","page":"Index","title":"Index","text":"Just a simple Julia package to define search spaces for, perhaps, optimization.","category":"page"},{"location":"#Installation","page":"Index","title":"Installation","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Open Julia (v1.7 or latest) and type the following command:","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> ]add SearchSpaces","category":"page"},{"location":"","page":"Index","title":"Index","text":"or ","category":"page"},{"location":"","page":"Index","title":"Index","text":"julia> import Pkg; Pkg.add(\"SearchSpaces\")","category":"page"},{"location":"#Quick-Start","page":"Index","title":"Quick Start","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"The search space can be composed by other spaces. Here, you can define custom search spaces as follows:","category":"page"},{"location":"","page":"Index","title":"Index","text":"Assume the following three search spaces: ","category":"page"},{"location":"","page":"Index","title":"Index","text":"beginmatrix\nX = 10 20 ldots 50\nY = textred textgreen textblue\nZ = 0 01 02 ldots 1\nendmatrix","category":"page"},{"location":"","page":"Index","title":"Index","text":"Let us define a mixed space X times Y times Z. Here, we can proceed as follows:","category":"page"},{"location":"","page":"Index","title":"Index","text":"using SearchSpaces # hide\nsearchspace = MixedSpace(\n                  :X => 10:10:50,\n                  :Y => [:red, :green, :blue],\n                  :Z => 0:0.1:1\n                  )","category":"page"},{"location":"","page":"Index","title":"Index","text":"Computing the cardinality of the search space:","category":"page"},{"location":"","page":"Index","title":"Index","text":"cardinality(searchspace)","category":"page"},{"location":"","page":"Index","title":"Index","text":"This can be useful to know how many items are in the search space.","category":"page"},{"location":"","page":"Index","title":"Index","text":"Now, let's sample some random elements in the mixed space.","category":"page"},{"location":"","page":"Index","title":"Index","text":"rand(searchspace)","category":"page"},{"location":"","page":"Index","title":"Index","text":"To sample every element in the search space, we can use the grid sampler:","category":"page"},{"location":"","page":"Index","title":"Index","text":"collect(Grid(searchspace))","category":"page"},{"location":"#Contents","page":"Index","title":"Contents","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Pages = [\"examples.md\", \"api.md\"]\nDepth = 3","category":"page"}]
}