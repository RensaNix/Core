{
  inputs,
  cell,
  ...
}: let
  inherit (inputs) pkgs dslib soonix treefmt;
  inherit (cell) ci;
in {
  default = dslib.mkShell {
    imports = [soonix.devshellModule];
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
    soonix.hooks.ci = ci.soonix;
  };
}
