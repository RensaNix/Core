{
  pkgs,
  ntlib,
  rensa,
  ...
}: {
  suites."Loader" = {
    pos = __curPos;
    tests = [
      {
        name = "cell sibling access";
        expected = {
          hello = "world";
        };
        actual = let
          testFlake = rensa.build {
            inputs = {};
            cellsFrom = ../cells;
            cellBlocks = with rensa.blocks; [
              (simple "test")
            ];
            systems = ["x86_64-linux"];
          };
        in
          testFlake.x86_64-linux.test.test;
      }
      {
        name = "load file";
        type = "script";
        script = ''
          ${ntlib.helpers.path [pkgs.gnugrep pkgs.coreutils pkgs.nix]}
          ${ntlib.helpers.scriptHelpers}

          mkdir -p "cells/testcell"
          echo '{ hello = "world"; }' > "cells/testcell/packages.nix"

          cat > "flake.nix" << 'EOF'
          {
            outputs = inputs: let
              rensa = import ${../lib} { lib = import "${pkgs.path}/lib"; };
            in rensa.build {
              inputs = {};
              cellsFrom = ./cells;
              cellBlocks = with rensa.blocks; [ (simple "packages") ];
              systems = [ "x86_64-linux" ];
            };
          }
          EOF

          result=$(nix eval --impure .#x86_64-linux.testcell.packages.hello)

          assert "$result == \"world\"" "should equal to world"
        '';
      }
    ];
  };
}
