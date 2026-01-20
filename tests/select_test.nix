{rensa, ...}: {
  suites."Select" = {
    pos = __curPos;
    tests = [
      {
        name = "single block";
        expected = {
          x86_64-linux = {value = "test-value";};
        };
        actual = let
          testFlake = {
            __ren = {
              cells = ["repo"];
            };
            x86_64-linux = {
              repo = {
                docs = {value = "test-value";};
                ci = {packages = {value = "ci-packages";};};
              };
            };
          };
        in
          rensa.select testFlake [["repo" "docs"]];
      }
      {
        name = "multiple blocks";
        expected = {
          x86_64-linux = {value = "ci-packages";};
        };
        actual = let
          testFlake = {
            __ren = {
              cells = ["repo"];
            };
            x86_64-linux = {
              repo = {
                ci = {packages = {value = "ci-packages";};};
                other = {value = "ignored";};
              };
            };
          };
        in
          rensa.select testFlake [
            ["repo" "ci" "packages"]
          ];
      }
    ];
  };
}
