{
  pkgs,
  ntlib,
  rensa,
  ...
}: {
  suites."Builder" = {
    pos = __curPos;
    tests = [
      {
        name = "has system outputs";
        expected = true;
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
          builtins.hasAttr "x86_64-linux" testFlake;
      }
      {
        name = "has ren metadata";
        expected = true;
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
          builtins.hasAttr "__ren" testFlake;
      }
      {
        name = "merges outputs";
        expected = {
          packages = {
            test-package = "merged";
          };
        };
        actual = let
          testFlake =
            rensa.buildWith {
              inputs = {};
              cellsFrom = ../cells;
              cellBlocks = with rensa.blocks; [
                (simple "test")
              ];
              systems = ["x86_64-linux"];
            } {
              packages = {
                test-package = "merged";
              };
            };
        in {
          packages = testFlake.packages;
        };
      }
      {
        name = "eval test";
        type = "script";
        script = ''
          ${ntlib.helpers.path [pkgs.gnugrep pkgs.coreutils pkgs.nix]}
          ${ntlib.helpers.scriptHelpers}

          result=$(nix eval --impure --expr '
            let
              rensa = import ${../lib} {lib = import ${pkgs.path}/lib;};
              testFlake = rensa.build {
                inputs = { test = "value"; };
                cellsFrom = ${../cells};
                cellBlocks = [];
                systems = [ "x86_64-linux" ];
              };
            in
              testFlake.__ren.__schema
          ')

          assert "$result == \"v0\"" "should contain version"
        '';
      }
    ];
  };
}
