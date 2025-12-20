# Tutorial

This tutorial will guide you through creating a new project using Rensa.

## Prerequisites

- Nix installed with flakes enabled.
- Optionally `direnv`.

## Step 1: Initialize the Flake

Create a new directory for your project and initialize a `flake.nix`:

```nix title="flake.nix"
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    ren.url = "gitlab:rensa-nix/core";
  };

  outputs = {ren, self, ...}@inputs: ren.buildWith {
    inherit inputs;
    cellsFrom = ./nix;
    cellBlocks = with ren.blocks; [
      (simple "packages")
    ];
    transformInputs = system: inputs: inputs // {
      pkgs = import inputs.nixpkgs { inherit system; };
    };
  } {
    packages = ren.select self [
      ["backend" "packages"]
    ];
  };
}
```

## Step 2: Create a Cell

Create a directory named `nix` and inside it, create a directory for your first cell, e.g., `backend`.

```bash
mkdir -p nix/backend
```

## Step 3: Add a Block

Inside `nix/backend`, create a file named `packages.nix`.
This will correspond to the `packages` block we defined in `flake.nix`.

Since we instantiated `pkgs` in the top-level `flake.nix`, we can access it via `inputs.pkgs`
(because we added it to inputs in `transformInputs`).

```nix
{
  inputs,
  cell,
}: {
  default = inputs.pkgs.hello;
}
```

### Using Cell Flakes (Advanced)

If your cell is a flake (has a `flake.nix`), you can access the parent inputs via `inputs.parent`.

**`nix/backend/flake.nix`**:

```nix
{
  inputs.common.url = "github:some/common-lib";
  outputs = inputs: inputs // {
    # inputs just for the current cell, for example:
    common = inputs.common.lib {inherit (inputs.parent) pkgs;};
  };
}
```

See [here](./libraries.md) for more information about this syntax.

**`cells/backend/packages.nix`**:

```nix
{
  inputs,
  cell,
}: {
  default = inputs.common.mkPackage { ... };
}
```

## Step 4: Build

Now you can build your package using the standard Nix commands:

```bash
nix build .#backend.packages.default
```

Or, if you mapped it in `flake.nix`:

```bash
nix build .#default
```

## Step 5: Setting up Direnv

Rensa provides a custom `direnv` integration. See the [Direnv Integration](direnv.md) guide for setup instructions.
