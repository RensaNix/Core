{
  l,
  utils,
}: let
  paths = import ./paths.nix;
  callFlake = import ./call-flake.nix;
  loader = import ./loader.nix {inherit l utils paths callFlake;};
  builder = import ./builder.nix {inherit l utils loader;};
in {
  inherit (builder) build buildWith;
}
