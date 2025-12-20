# Rensa

Rensa is a powerful and flexible Nix flake framework designed to organize your Nix projects into logical units called "Cells".
It is heavily inspired by [divnix/std](https://github.com/divnix/std) but aims to provide a streamlined experience.
Feel free to check out std's awesome [docs](https://std.divnix.com/reference/std.html) too.

## Features

- **Cells**: Organize your code into functional domains (e.g., `backend`, `frontend`, `devops`).
- **Blocks**: Define types of outputs within a cell (e.g., `packages`, `devShells`, `nixosConfigurations`).
- **Actions**: Integrate with the CLI to run commands defined in your cells.
- **Cell Flakes**: Each cell can be its own flake, allowing for modular dependency management.

## Quick Start

1. **Initialize a Flake**: Create a `flake.nix` that uses `rensa`.
1. **Define Cells**: Create a `cells/` directory.
1. **Add Blocks**: Add `.nix` files in your cells to define outputs.

### Example `flake.nix`

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    ren.url = "gitlab:rensa-nix/core";
  };

  outputs = {ren, ...}@inputs: ren.buildWith {
    inherit inputs;
    cellsFrom = ./cells;
    cellBlocks = with ren.blocks; [
      (simple "packages")
      (simple "devShells")
    ];
  } {
    packages = ren.select inputs.self [
      ["my-cell" "packages"]
    ];
  };
}
```

See the [docs](https://rensa.projects.tf) for more.
