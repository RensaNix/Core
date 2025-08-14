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
      cellsFrom = ./cells;
      cellBlocks = with rensa.blocks; [
        (simple "test")
        (simple "devShells")
      ];
    } {};
}
