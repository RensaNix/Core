{
  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = inputs: import ./. {
    inherit (inputs.nixpkgs-lib) lib;
  };
}
