# API Reference

## `rensa.buildWith`

The main entry point for creating a Rensa flake.

### Arguments

- `inputs`: The flake inputs.
- `cellsFrom`: Path to the directory containing your cells.
- `cellBlocks`: A list of blocks to load for each cell. Defaults to `[rensa.blocks.autodiscover]`.
- `transformInputs` (optional): A function to transform inputs before they are passed to cells.

### Returns

A standard Nix flake output set.

## `rensa.build`

The underlying builder function used by `buildWith`. It returns the raw Rensa output structure without the recursive update functor.

### Arguments

- `inputs`: The flake inputs.
- `cellsFrom`: Path to the directory containing your cells.
- `cellBlocks`: A list of blocks to load for each cell. Defaults to `[rensa.blocks.autodiscover]`.
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

### `autodiscover`

```nix
autodiscover
# or
(autodiscover "cellName")
```

Automatically discovers and loads all cell blocks by scanning the cells directory for `.nix` files.
When `autodiscover` is present in `cellBlocks`, Rensa will:

1. Walk through all cells in `cellsFrom` (or specific cell if provided).
1. Find all `.nix` files (excluding `flake.nix`).
1. Find all directories containing `default.nix`.
1. Generate `simple` block definitions for each discovered block.

**Usage patterns:**

```nix
# full autodiscovery
cellBlocks = with rensa.blocks; [
  autodiscover
];
# or
cellBlocks = with rensa.blocks; [
  (autodiscover "backend")  # only discover blocks from backend cell
  (autodiscover "frontend") # only discover blocks from frontend cell
];
# mixed
cellBlocks = with rensa.blocks; [
  (simple "myBlock")  # explicit block (takes precedence)
  autodiscover        # discover all others
];
```

!!! note

    When a block is both explicitly defined and discovered, the explicit definition takes precedence.

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
