{inputs, ...}: let
  inherit (inputs) pkgs dslib;
in {
  default = dslib.mkShell {
    packages = [pkgs.alejandra];
    enterShellCommands."ren".text = "echo Hello rensa!";
  };
}
