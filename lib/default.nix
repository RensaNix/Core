{lib}: let
  l = builtins // lib;
  utils = import ./utils {inherit l;};
  core = import ./core {inherit l utils;};
  compat = import ./compat {inherit l;};
in {
  inherit (compat) filter select get;
  inherit (core) build buildWith;
  # TODO:
  # blocks = import ./blocks;
}
