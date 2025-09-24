{l}: let
  filter = pred: t: p: let
    multiplePaths = l.isList (l.elemAt p 0);

    # function to expand wildcards in a path
    expandPath = path:
      if !(l.elem "*" path)
      then [path]
      else let
        availableCells = t.__ren.cells or [];

        # get the first valid system
        sampleSystem = l.head (l.filter (n: l.elem n l.systems.doubles.all) (l.attrNames t));

        # handle different wildcard positions
        expandWildcardAt = pos:
          if pos >= l.length path
          then [path]
          else if (l.elemAt path pos) != "*"
          then expandWildcardAt (pos + 1)
          else let
            prefix = l.take pos path;
            suffix = l.drop (pos + 1) path;

            choices =
              if pos == 0 # cell names
              then availableCells
              else if pos == 1 # cell block names
              then let
                cellName = l.elemAt path 0;
                cellAttrs = t.${sampleSystem}.${cellName} or {};
              in
                l.attrNames cellAttrs
              else # target names (pos >= 2)
                let
                  cellName = l.elemAt path 0;
                  blockName = l.elemAt path 1;
                  blockAttrs = t.${sampleSystem}.${cellName}.${blockName} or {};
                in
                  l.attrNames blockAttrs;

            expandedPaths = l.map (choice: prefix ++ [choice] ++ suffix) choices;
          in
            # recursively expand any remaining wildcards in each expanded path
            l.concatMap expandPath expandedPaths;
      in
        expandWildcardAt 0;

    # expand all paths that contain wildcards
    expandedPaths =
      if multiplePaths
      then l.concatMap expandPath p
      else expandPath p;

    hoist = path: let
      result =
        l.filterAttrs (
          n: v:
            (l.elem n l.systems.doubles.all)
            && (l.hasAttrByPath path v)
        )
        t;
    in
      if result == {}
      then null # return null for non-matching paths
      else
        l.mapAttrs (
          _: v: let
            attr = l.getAttrFromPath path v;
          in
            if pred == true
            then attr
            else l.filterAttrs pred attr
        )
        result;

    # process all expanded paths and merge results
    results = l.map hoist expandedPaths;
    validResults = l.filter (r: r != null) results;
  in
    if validResults == []
    then builtins.abort "[ren] filter: No matching paths found for ${toString p}. Expanded to: ${toString expandedPaths}"
    else l.foldl' l.recursiveUpdate {} validResults;
in
  filter
