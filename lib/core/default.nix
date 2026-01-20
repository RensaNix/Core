{
  l,
  utils,
  blocks,
}: let
  paths = import ./paths.nix;
  callFlake = import ./call-flake.nix;
  autodiscover = import ./autodiscover.nix;
  loader = import ./loader.nix {inherit l utils paths callFlake;};
  builder = import ./builder.nix {inherit l utils loader autodiscover blocks;};
in {
  inherit (builder) build buildWith;
}
