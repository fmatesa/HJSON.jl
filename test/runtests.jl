using HJSON
using JSON
using Test

@testset "HJSON.jl" begin
    @testset "read_hjson" begin
        dict = HJSON.read_hjson("test.hjson")

        @test dict["test"] === "test"
    end

    @testset "to_json" begin
        HJSON.to_json("test.hjson", "result.json")
        @test isfile("result.json")

        dict = JSON.parsefile("result.json", use_mmap=false)
        @test dict["test"] === "test"

        rm("result.json")
    end

    @testset "to_hjson" begin
        HJSON.to_json("test.json", "result.hjson")
        @test isfile("result.hjson")

        dict = HJSON.read_hjson("result.hjson")
        @test dict["test"] === "test"

        rm("result.hjson")
    end
end
