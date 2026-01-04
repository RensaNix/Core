{
  pkgs,
  ntlib,
  ...
}: {
  suites."Autodiscovery" = {
    pos = __curPos;
    tests = [
      {
        name = "find nix files";
        type = "script";
        script = ''
          ${ntlib.helpers.path [pkgs.gnugrep pkgs.coreutils pkgs.nix]}
          ${ntlib.helpers.scriptHelpers}

          mkdir -p "testcell"
          echo '{ foo = "bar"; }' > "testcell/packages.nix"
          echo '{ baz = "qux"; }' > "testcell/devShells.nix"
          echo '{ ignored = true; }' > "testcell/flake.nix"

          result=$(nix eval --impure --expr '
            let
              lib = import ${pkgs.path}/lib;
              autodiscover = import ${../lib/core/autodiscover.nix} {
                l = builtins // lib;
                cellsFrom = ./.;
                cellBlocks = [ { name = "__autodiscover"; } ];
              };
            in
              builtins.length (builtins.filter (b: b.name == "packages" || b.name == "devShells") autodiscover)
          ')

          assert_eq "$result" "2" "should discover 2 blocks"
        '';
      }
      {
        name = "finds directories";
        type = "script";
        script = ''
          ${ntlib.helpers.path [pkgs.gnugrep pkgs.coreutils pkgs.nix]}
          ${ntlib.helpers.scriptHelpers}

          mkdir -p "testcell/packages"
          echo '{ hello = "world"; }' > "testcell/packages/default.nix"

          result=$(nix eval --impure --expr '
            let
              lib = import ${pkgs.path}/lib;
              autodiscover = import ${../lib/core/autodiscover.nix} {
                l = builtins // lib;
                cellsFrom = ./.;
                cellBlocks = [ { name = "__autodiscover"; } ];
              };
            in
              builtins.any (b: b.name == "packages") autodiscover
          ')

          assert "$result == true" "Should discover directory with default.nix"
        '';
      }
    ];
  };
}
