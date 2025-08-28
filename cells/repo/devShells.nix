{inputs, ...}: let
  inherit (inputs) pkgs dslib treefmt;
in {
  default = dslib.mkShell {
    packages = [
      (treefmt.mkWrapper pkgs {
        programs = {
          alejandra.enable = true;
          mdformat.enable = true;
        };
        settings.global.excludes = ["*LICENSE*.md"];
      })
    ];
    enterShellCommands."ren".text = "echo Hello rensa!";
  };
}
