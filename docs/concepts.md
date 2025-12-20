# Concepts

Rensa is built around a few core concepts that help structure your Nix projects.

## Cells

A **Cell** is the fundamental unit of organization in Rensa.
It represents a functional domain or a component of your system.
For example, you might have cells for:

- `backend`: Your backend services.
- `frontend`: Your frontend applications.

Cells are directories located in the `cellsFrom` directory (usually `cells/` or `nix/`).

### Cell Flakes

A unique feature of Rensa is that each cell can be a self-contained Flake.
If a cell directory contains a `flake.nix`, Rensa will treat it as a flake and pass its outputs to the cell's blocks.
This allows you to manage dependencies at the cell level, keeping your top-level `flake.nix` clean.

!!! success "Advantage"

    These nested flakes are also evaluated lazily, so inputs are only fetched if they are actually used.

## Blocks

A **Block** defines a specific type of output within a cell. Blocks are typically defined as `.nix` files within a cell directory.
Rensa provides different block types to handle various use cases.

### Simple Blocks

`rensa.blocks.simple` is the most common block type.
Use it to tell Rensa which blocks you have/it should load.

**Example**:

```nix
blocks = with ren.blocks; [
  (simple "hello")
]
```

This will tell Rensa to load any `hello.nix` or `hello/default.nix` in the cells.
It's required to be able to map these to flake outputs (eg. using `ren.select`).

### Dynamic Blocks

`rensa.blocks.dynamic` allows for more complex logic and can generate actions.

## Actions

**Actions** are commands that can be executed via the Std CLI.
They are defined within blocks and allow you to operationalize your Nix code.
For example, a `deploy` action in an `infra` cell could run the necessary commands to deploy your infrastructure.

!!! warning

    Actions are also heavily inspired by Std, I added them to Rensa too, but nowadays
    I don't see any real use cases for them. If you do, feel free to use and/or extend them :)

## Performance & Best Practices

### Single Instantiation of Nixpkgs

Instantiating `nixpkgs` (e.g., `import inputs.nixpkgs { inherit system; }`) is a computationally expensive operation. In a large project with many cells, doing this repeatedly for every cell or block can significantly slow down evaluation.

The recommended pattern in Rensa is to instantiate `nixpkgs` **once** in your top-level `flake.nix` and pass it down to your cells.

1. **Instantiate in `transformInputs`**: In your `flake.nix`, use the `transformInputs` argument of `buildWith` to add the instantiated `pkgs` to the inputs passed to cells.
1. **Use `i.parent.pkgs`**: In your cell flakes, access this pre-instantiated package set via `inputs.parent.pkgs`.

This ensures that `nixpkgs` is evaluated only once per system, drastically improving performance.

See [Related Libraries](./libraries.md) for examples of this pattern.
