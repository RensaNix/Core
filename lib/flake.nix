{
  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = inputs: {
    lib = import ./. {
      inherit (inputs.nixpkgs-lib) lib;
    };
  };
}
