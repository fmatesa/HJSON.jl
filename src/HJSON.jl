module HJSON

using Hjson_jll
using JSON
using JSON3

export to_json
export to_hjson
export read_hjson

include("functions.jl")

end
