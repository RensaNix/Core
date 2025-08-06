{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: let
    rensa = import ./lib {
      inherit (inputs.nixpkgs) lib;
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
