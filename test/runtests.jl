using Test
using SearchSpaces

@testset "API" begin

    @testset "Bounds" begin
        bounds = Bounds(lb = [0, -5], ub = [10, 5])
        @test cardinality(bounds) == 11*11
        @test size(sample(RandomInDomain(10), bounds)) == (10,2)

        bounds_c = Bounds(lb = [-1.0, -1.0], ub = [3.0, 2.0])
        @test !isfinite(cardinality(bounds_c))
        @test isinbounds(zeros(2), bounds_c)
        @test !isinbounds(fill(-1000, 2), bounds_c)
    end

    @testset "Permutations" begin
        perms  = Permutations(5)
        @test cardinality(perms)  == prod(2:5)
        @test size(sample(RandomInDomain(10), perms)) == (10,5)
        @test ispermutation(1:perms.dim, perms)
        @test !ispermutation(ones(Int, 5), perms)
    end

    @testset "BitArrays" begin
        bits   = BitArrays(dim = 3)
        @test cardinality(bits)   == 8
        @test size(sample(RandomInDomain(10), bits)) == (10, 3)
    end

    @testset "SearchSpace" begin
        bounds = Bounds(lb = [0, -5], ub = [10, 5])
        perms  = Permutations(5)
        bits   = BitArrays(dim = 3)
        ss = SearchSpace(:x => bounds,
                         :y => perms,
                         :z => bits
                        ) 

        @test cardinality(ss) == 11*11*prod(1:5)*8
        @test sample(RandomInDomain(10), ss) isa Dict
    end



end
