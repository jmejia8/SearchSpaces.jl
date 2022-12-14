using Test
using SearchSpaces

# put here example of search spaces
const AVAILABLE_SPACES = [
                          # variants for defining permutations
                          Permutations(5),
                          Permutations([:red, :green, :blue]),
                          Permutations([:red, :green, :blue, :alpha], 2),
                          # variants for defining bit arrays
                          BitArrays(4),
                          # defining different type of bounds
                          Bounds(lb = 1.1, ub = 4.1),
                          Bounds(lb = zeros(5), ub = ones(5)),
                          Bounds(lb = fill(-10, 3), ub = fill(10, 3)),
                          Bounds(lb = zeros(2), ub = ones(2), rigid=false),
                          # mixed search space
                          MixedSpace(:X => Permutations(3),
                                     :Y => BitArrays(3),
                                     :Z => Bounds(lb = zeros(2), ub = ones(2)),
                                    ) 
                         ]

@testset "API" begin

    @testset "Bounds" begin
        bounds = Bounds(lb = [0, -5], ub = [10, 5])
        @test cardinality(bounds) == 11*11

        bounds_c = Bounds(lb = [-1.0, -1.0], ub = [3.0, 2.0])
        @test !isfinite(cardinality(bounds_c))
        @test isinbounds(zeros(2), bounds_c)
        @test !isinbounds(fill(-1000, 2), bounds_c)
    end

    @testset "Permutations" begin
        perms  = Permutations(5)
        @test cardinality(perms)  == prod(2:5)
        @test ispermutation(1:perms.dim, perms)
        @test !ispermutation(ones(Int, 5), perms)

        perms  = Permutations([:red, :green, :blue, :alpha, :pink], 3)
        @test ispermutation([:alpha, :green, :pink], perms)
        @test !ispermutation([:alpha , :pink], perms)
        @test !ispermutation([:green, :green, :red], perms)
    end

    @testset "BitArrays" begin
        bits   = BitArrays(dim = 3)
        @test cardinality(bits)   == 8
    end

    @testset "SearchSpace" begin
        bounds = Bounds(lb = [0, -5], ub = [10, 5])
        perms  = Permutations(5)
        bits   = BitArrays(dim = 3)
        ss = MixedSpace(:x => bounds,
                         :y => perms,
                         :z => bits
                        ) 

        @test cardinality(ss) == 11*11*prod(1:5)*8
    end

    @testset "Variables" begin

        for searchspace in AVAILABLE_SPACES
            x = Variable(:x, searchspace)
            @test x isa Variable
            @test x.searchspace == searchspace
            @var y in searchspace
            @test y isa Variable
            @test y.name === :y
            @test y.searchspace == searchspace
        end

    end

    @testset "Samplers" begin
        @test length(collect(Grid(Permutations(3)))) == length(Grid(Permutations(3)))
        @test length(collect(Grid(Bounds(lb=[-1.0, -1],ub=[1.0, 3])))) == length(Grid(Bounds(lb=[-1.0, -1],ub=[1, 3.0])))
        for sampler in [Grid, AtRandom]
            for searchspace in AVAILABLE_SPACES
                # sample at most 3 elements
                for (x, _) in zip(sampler(searchspace), 1:3)
                    @test isinspace(x, searchspace)
                end
            end
        end
    end

    # check length of the grid
    for searchspace in AVAILABLE_SPACES
        sampler = Grid(searchspace)
        @test length(collect(sampler)) == length(sampler)
    end

end
