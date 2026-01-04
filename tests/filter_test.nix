{rensa, ...}: {
  suites."Filter" = {
    pos = __curPos;
    tests = [
      {
        name = "filter by cell";
        expected = {
          x86_64-linux = {};
        };
        actual = let
          testFlake = {
            __ren = {
              cells = ["repo" "other"];
            };
            x86_64-linux = {
              repo = {
                docs = {value = "docs-value";};
                ci = {value = "ci-value";};
              };
              other = {
                packages = {value = "other-packages";};
              };
            };
          };
        in
          rensa.filter (_: cell: cell == "repo") testFlake [["*" "*"]];
      }
      {
        name = "filter by block";
        expected = {
          x86_64-linux = {};
        };
        actual = let
          testFlake = {
            __ren = {
              cells = ["repo"];
            };
            x86_64-linux = {
              repo = {
                docs = {value = "docs-value";};
                ci = {value = "ci-value";};
                packages = {value = "packages-value";};
              };
            };
          };
        in
          rensa.filter (block: _: block == "docs") testFlake [["repo" "*"]];
      }
    ];
  };
}
