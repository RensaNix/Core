# API Reference

## `rensa.buildWith`

The main entry point for creating a Rensa flake.

### Arguments

- `inputs`: The flake inputs.
- `cellsFrom`: Path to the directory containing your cells.
- `cellBlocks`: A list of blocks to load for each cell.
- `transformInputs` (optional): A function to transform inputs before they are passed to cells.

### Returns

A standard Nix flake output set.

## `rensa.build`

The underlying builder function used by `buildWith`. It returns the raw Rensa output structure without the recursive update functor.

### Arguments

- `inputs`: The flake inputs.
- `cellsFrom`: Path to the directory containing your cells.
- `cellBlocks`: A list of blocks to load for each cell.
- `transformInputs` (optional): A function to transform inputs.

### Returns

An attribute set containing:

- `output`: The generated flake outputs.
- `__ren`: Internal metadata about the cells and blocks.

## `rensa.blocks`

Helper functions to define blocks.

### `simple`

```nix
simple "name"
```

Creates a block definition where the type matches the name.

### `dynamic`

```nix
dynamic "name"
```

Creates a block definition for dynamic content. This allows integration of the `std` cli
by passing through actions etc. from a cell.

Currently not really used.

## `rensa.select`

Helper to select specific outputs from the generated flake.

```nix
select inputs.self [
  ["cellName" "blockName" "outputName"]
]
```

## `rensa.filter`

Filters the generated flake outputs based on a predicate and paths.

```nix
filter predicate inputs.self [
  ["cellName" "blockName" "outputName"]
]
```

### Arguments

- `predicate`: A function or boolean. If `true`, returns the attribute as is. If a function, it's used to filter the attributes of the target.
- `target`: The flake outputs (usually `inputs.self`).
- `paths`: A list of paths to select. Supports wildcards (`*`).

## `rensa.get`

Retrieves a single attribute from the flake outputs.

```nix
get inputs.self ["cellName" "blockName" "outputName"]
```

### Arguments

- `target`: The flake outputs.
- `path`: The path to the attribute to retrieve.
