{lib}: let
  l = builtins // lib;
  blocks = import ./blocks;
  utils = import ./utils {inherit l;};
  compat = import ./compat {inherit l;};
  core = import ./core {inherit l utils blocks;};
in {
  inherit (compat) filter select get;
  inherit (core) build buildWith;
  inherit blocks;
}
