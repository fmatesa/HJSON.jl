module HJSON

using Hjson_jll
using JSON

export to_json
export to_hjson
export read_hjson

include("functions.jl")

end
