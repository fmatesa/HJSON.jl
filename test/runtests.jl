using HJSON
using JSON
using Test

@testset "HJSON.jl" begin
    @testset "read_hjson" begin
        dict = HJSON.read_hjson("test.hjson")

        @test dict["test"] === "test"

        dict = HJSON.read_hjson("test.hjson", true)
        @test dict[:test] === "test"

        dict = HJSON.read_hjson("{test: test}")
        @test dict["test"] === "test"

        dict = HJSON.read_hjson("large.hjson", true)
        @test 1==1

    end

    @testset "to_json" begin
        HJSON.to_json("test.hjson", "result.json")
        @test isfile("result.json")

        dict = JSON.parsefile("result.json", use_mmap=false)
        @test dict["test"] === "test"

        rm("result.json")

        HJSON.to_json("large.hjson", "result.json")
        @test isfile("result.json")

        rm("result.json")
    end

    @testset "to_hjson" begin
        HJSON.to_hjson("test.json", "result.hjson")
        @test isfile("result.hjson")

        dict = HJSON.read_hjson("result.hjson")
        @test dict["test"] === "test"

        rm("result.hjson")

        HJSON.to_hjson("large.json", "result.hjson")
        @test isfile("result.hjson")

        rm("result.hjson")
    end

    @testset "to_hjson dictionary" begin
        testdict = Dict(:test => "test")
        HJSON.to_hjson(testdict, "result.hjson")
        @test isfile("result.hjson")

        dict = HJSON.read_hjson("result.hjson")
        @test dict["test"] === "test"

        rm("result.hjson")
    end
end
