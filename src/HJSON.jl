module HJSON

using Hjson_jll
using JSON
using JSON3
using OrderedCollections

export to_json
export to_hjson
export read_hjson

include("functions.jl")

end
