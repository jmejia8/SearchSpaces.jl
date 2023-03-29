using Test
using SearchSpaces
import Random

# Aqua: Auto QUality Assurance for Julia packages
using Aqua
Aqua.test_all(SearchSpaces)

# put here example of search spaces
const AVAILABLE_SPACES = [
                          # variants for defining permutations
                          PermutationSpace(5),
                          PermutationSpace([:red, :green, :blue]),
                          PermutationSpace([:red, :green, :blue, :alpha], 2),
                          CombinationSpace([:red, :green, :blue, :alpha], 2),
                          CombinationSpace([:red, :green, :blue]),
                          CombinationSpace(5),
                          # variants for defining bit arrays
                          BitArraySpace(4),
                          # defining different type of bounds
                          BoxConstrainedSpace(lb = 1.1, ub = 4.1),
                          BoxConstrainedSpace(lb = zeros(5), ub = ones(5)),
                          BoxConstrainedSpace(lb = fill(-10, 3), ub = fill(10, 3)),
                          BoxConstrainedSpace(lb = zeros(2), ub = ones(2), rigid=false),
                          # mixed search space
                          MixedSpace(:X => PermutationSpace(3),
                                     :Y => BitArraySpace(3),
                                     :Z => BoxConstrainedSpace(lb = zeros(2), ub = ones(2)),
                                    ) ,
                          # mixed with native iterators
                          MixedSpace(:x => 1:10, :y => [:red, :green], :z => PermutationSpace(1:3))
                         ]

const AVAILABLE_SAMPLERS = [Grid, AtRandom]

@testset verbose = true "API" begin

    @testset "BoxConstrainedSpace" begin
        bounds = BoxConstrainedSpace(lb = [0, -5], ub = [10, 5])
        @test cardinality(bounds) == 11*11
        @test [1, 3] in bounds
        @test !([1, 3, 1] in bounds)
        @test !([1000, 3] in bounds)

        bounds_c = BoxConstrainedSpace(lb = [-1.0, -1.0], ub = [3.0, 2.0])
        @test !isfinite(cardinality(bounds_c))
        @test isinbounds(zeros(2), bounds_c)
        @test !isinbounds(fill(-1000, 2), bounds_c)
        @test [0.4, 0.3] in bounds_c
        @test !([33.4, 10.13] in bounds_c)
        @test !([0.4, 0.3, 0.1] in bounds_c)
    end

    @testset "PermutationSpace" begin
        perms  = PermutationSpace(5)
        @test cardinality(perms)  == prod(2:5)
        @test ispermutation(1:perms.dim, perms)
        @test !ispermutation(ones(Int, 5), perms)
        @test collect(1:5) in perms
        @test !(collect(1:3) in perms)
        @test !([1,2,2,2,5] in perms)

        perms  = PermutationSpace([:red, :green, :blue, :alpha, :pink], 3)
        @test ispermutation([:alpha, :green, :pink], perms)
        @test !ispermutation([:alpha , :pink], perms)
        @test !ispermutation([:green, :green, :red], perms)
    end

    @testset "CombinationSpace" begin
        comb  = CombinationSpace(1:10, 3)
        @test cardinality(comb)  == 220
        @test iscombination(ones(Int, 3), comb)
        @test !(collect(1:5) in comb)
        @test collect(1:3) in comb
        @test !([1,2,2,2,5] in comb)

        comb  = CombinationSpace([:red, :green, :blue], 6)
        @test iscombination(fill(:green, 6), comb)
        @test !iscombination([:alpha , :pink], comb)
        @test !iscombination([:green, :green, :red], comb)
    end

    @testset "BitArraySpace" begin
        bits   = BitArraySpace(dim = 3)
        @test cardinality(bits)   == 8
        @test rand(Bool, 3) in bits
        @test !(rand(Bool, 4) in bits)
        @test !([1,2,3] in bits)
    end

    @testset "MixedSpace" begin
        bounds = BoxConstrainedSpace(lb = [0, -5], ub = [10, 5])
        perms  = PermutationSpace(5)
        bits   = BitArraySpace(dim = 3)
        ss = MixedSpace( :X => bounds,
                         :Y => perms,
                         :Z => bits
                        ) 

        @test cardinality(ss) == 11*11*prod(1:5)*8
        @test rand(ss) in ss
        @test Dict(:X => 1, :Y => 2, :Z => 3) ∉ ss
        @test Dict(:X => [0,0], :Y => collect(1:5), :Z => zeros(Bool,3), :W => 1) ∉ ss

        @test bounds × ss isa MixedSpace
        @test ss × bounds isa MixedSpace
        @test bounds × perms  × bits × perms isa MixedSpace
        
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
        # check samplers
        for sampler in AVAILABLE_SAMPLERS
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
        # check length in Grid
        @test length(collect(sampler)) == length(sampler)
        # check random generators
        @test isinspace(rand(searchspace), searchspace)
        for x in rand(searchspace, 3)
            @test isinspace(x, searchspace)
        end
        @test ismissing(missing in searchspace)
    end
end

