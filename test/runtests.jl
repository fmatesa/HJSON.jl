using HJSON
using JSON
using Test

@testset "HJSON.jl" begin
    @testset "read_hjson" begin
        dict = HJSON.read_hjson("hjson/test.hjson")

        @test dict["test"] === "test"

        dict = HJSON.read_hjson("hjson/test.hjson", true)
        @test dict[:test] === "test"

        dict = HJSON.read_hjson("hjson/test_brackets.hjson")

        @test dict[1]["test"] === "test"
        @test dict[2]["test2"] === "test2"

        dict = HJSON.read_hjson("{test: test}")
        @test dict["test"] === "test"

        dict = HJSON.read_hjson("hjson/large.hjson", true)
        @test 1==1

    end

    @testset "to_json" begin
        HJSON.to_json("hjson/test.hjson", "json/result.json")
        @test isfile("json/result.json")

        dict = JSON.parsefile("json/result.json", use_mmap=false)
        @test dict["test"] === "test"

        rm("json/result.json")

        HJSON.to_json("hjson/large.hjson", "json/result.json")
        @test isfile("json/result.json")

        rm("json/result.json")
    end

    @testset "to_hjson" begin
        HJSON.to_hjson("json/test.json", "hjson/result.hjson")
        @test isfile("hjson/result.hjson")

        dict = HJSON.read_hjson("hjson/result.hjson")
        @test dict["test"] === "test"

        rm("hjson/result.hjson")

        HJSON.to_hjson("json/large.json", "hjson/result.hjson")
        @test isfile("hjson/result.hjson")

        rm("hjson/result.hjson")
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
