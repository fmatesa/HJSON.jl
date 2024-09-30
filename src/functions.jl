"""
    to_hjson(fpath_input, fpath_output; kwargs...)
    to_hjson(input::AbstractDict, fpath_output; kwargs...)

Translate a .json file or dictionary to .hjson.

# Keywords

- `bracesSameLine`: defaults to false
- `indent_by`: a custom string to be used instead of default whitespace for indentation.
    Defaults to nothing
- `omit_root_braces`: defaults to false
- `preserve_key_order`: defaults to false
- `quote_always`: Always writes quotation marks around string arguments. Defaults to false.
- `async`: If this value is true, the CLI call will be asynchronous
"""
function to_hjson(
    fpath_input, fpath_output; 
    braces_same_line=false, 
    indent_by=nothing, 
    omit_root_braces=false, 
    preserve_key_order=false, 
    quote_always=false,
    async=false
)
    args = _hjson_args(; braces_same_line, indent_by, omit_root_braces, preserve_key_order, quote_always)
    
    run(pipeline(`$(Hjson_jll.hjson()) $args`; stdin=fpath_input, stdout=fpath_output); wait=!async)
    return nothing
end

function to_hjson(input::AbstractDict, fpath_output; kwargs...)
    mktemp() do path, io
        JSON3.pretty(io, input)
        close(io)
        to_hjson(path, fpath_output; kwargs...)
    end

    return nothing
end

"""
    read_hjson(input::String, keys_as_symbols=false)

Read a .hjson file from a given filepath or string and return the result as a Dictionary.
Dictionary strings will be symbols instead of keys if `keys_as_symbols` is set to true.
"""
function read_hjson(input::String, keys_as_symbols=false)
    !startswith(input, "{") && return to_json(input, nothing; formatted=false, keys_as_symbols)
    input = replace(input, "}" => "\n}", "{" => "\n{")
    mktemp() do path, io
        write(io, input)
        close(io)
        return read_hjson(path, keys_as_symbols)
    end
end

"""
    to_json(fpath_input, fpath_output; kwargs...)

Translate a .hjson file to .json.
If `fpath_output` is nothing, read a .hjson file and return the result as a Dictionary
instead of saving it.

# Keywords

- `formatted`: Defaults to true. If false, the result will be written in a single line
- `indent_by`: a custom string to be used instead of default whitespace for indentation.
    Defaults to nothing
- `preserve_key_order`: defaults to false
- `async`: If this value is true, the CLI call will be asynchronous
"""
function to_json(
    fpath_input, fpath_output; 
    formatted=true, indent_by=nothing, preserve_key_order=false, keys_as_symbols=false, async=false
)
    args = _hjson_args(; output_type="JSON", formatted, indent_by, preserve_key_order)

    json = Pipe()
    run(pipeline(`$(Hjson_jll.hjson()) $args`; stdin=fpath_input, stdout=json); wait=!async)

    isnothing(fpath_output) && !keys_as_symbols && return JSON.parse(json)

    close(json.in)

    if isnothing(fpath_output) && keys_as_symbols
        json_string = read(json, String)
        return copy(JSON3.read(json_string))
    end

    open(fpath_output, "w") do f
        write(f, json.out)
    end

    return Dict{String, Any}()
end


"""
    _hjson_args(; kwargs...)

Create an array of arguments for the hjson-cli command call.

# Keywords

- `bracesSameLine`: defaults to false
- `output_type`: either "JSON" or "HJSON". Defaults to "HJSON".
- `formatted`: Defaults to true. If false, the result will be written in a single line.
    Only used if `output_type` is JSON.
- `indent_by`: a custom string to be used instead of default whitespace for indentation.
    Defaults to nothing
- `omit_root_braces`: defaults to false
- `preserve_key_order`: defaults to false
- `quote_always`: Always writes quotation marks around string arguments. Defaults to false.
"""
function _hjson_args(; 
    braces_same_line=false, 
    output_type="HJSON", 
    formatted=true,
    indent_by=nothing, 
    omit_root_braces=false, 
    preserve_key_order=false, 
    quote_always=false
)
    args = []
    braces_same_line && push!(args, "-bracesSameLine")
    output_type == "JSON" && push!(args, formatted ? "-j" : "-c")
    if !isnothing(indent_by)
        push!(args, "-indentBy")
        push!(args, indent_by)
    end
    omit_root_braces && push!(args, "-omitRootBraces")
    preserve_key_order && push!(args, "-preserveKeyOrder")
    quote_always && push!(args, "-quoteAlways")

    return args
end