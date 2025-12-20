{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = inputs: let
    rensa = import ./lib {
      inherit (inputs.nixpkgs-lib) lib;
    };
  in
    rensa.buildWith {
      inherit inputs;
      transformInputs = system: i:
        i
        // {
          pkgs = import i.nixpkgs {inherit system;};
        };
      cellsFrom = ./cells;
      cellBlocks = with rensa.blocks; [
        (simple "test")
        (simple "devShells")
        (simple "docs")
        (simple "ci")
        (simple "soonix")
      ];
    } {
      packages = rensa.select inputs.self [
        ["repo" "docs"]
        ["repo" "ci" "packages"]
        ["repo" "soonix" "packages"]
      ];
    };
}
