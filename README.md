## Overview

A small wrapper for the Hjson_jll package.
Provides the option to translate .json files to .hjson and vice-versa, and has the ability to read .hjson files and output them as `Dict` objects.

[![Build Status](https://github.com/fmatesa/hjson.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/fmatesa/hjson.jl/actions/workflows/CI.yml?query=branch%3Amaster)

## Usage

```
julia> using hjson

julia> to_json("filepath.hjson", "filepath.json")

julia> to_hjson("filepath.json", "filepath.hjson")

julia> read_hjson("filepath.hjson")
```

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/JuliaDiff/BlueStyle)
