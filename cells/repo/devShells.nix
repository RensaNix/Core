{inputs, ...}: let
  inherit (inputs) pkgs devshellLib;
in {
  default = devshellLib.mkShell {
    packages = [pkgs.alejandra];
  };
}
