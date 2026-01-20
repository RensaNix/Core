{
  l,
  cellsFrom,
  cellBlocks,
}: let
  # find autodiscover blocks
  autodiscoverBlocks = l.filter (block: block.name or "" == "__autodiscover") cellBlocks;
  explicitBlocks = l.filter (block: block.name or "" != "__autodiscover") cellBlocks;
  hasAutodiscover = (l.length autodiscoverBlocks) > 0;

  # discover all block names from a single cell's directory
  discoverBlocksFromCell = cellPath: let
    cellContents = l.readDir cellPath;
    # filter for .nix files (but not flake.nix) and dirs with default.nix
    blockNames = l.unique (
      l.filter (name: name != null) (
        l.mapAttrsToList (
          name: type:
            if type == "regular" && l.hasSuffix ".nix" name && name != "flake.nix"
            then l.removeSuffix ".nix" name
            else if type == "directory" && l.pathExists (cellPath + "/${name}/default.nix")
            then name
            else null
        )
        cellContents
      )
    );
  in
    builtins.addErrorContext "[ren] while discovering blocks from cell ${cellPath}"
    blockNames;

  # discover all blocks from all cells or specific cells
  discoverAllBlocks = let
    # check if any autodiscover blocks have cell-specific targets (eg. `autodiscover "a"`)
    cellSpecificDiscoveries = l.filter (block: block ? cell) autodiscoverBlocks;
    globalDiscoveries = l.filter (block: !(block ? cell)) autodiscoverBlocks;

    cellSpecificBlocks = l.flatten (
      l.map (
        block: let
          cellPath = cellsFrom + "/${block.cell}";
        in
          if l.pathExists cellPath
          then discoverBlocksFromCell cellPath
          else []
      )
      cellSpecificDiscoveries
    );

    # global autodiscover
    globalBlocks = builtins.addErrorContext "[ren] while discovering global blocks" (
      if (l.length globalDiscoveries) > 0
      then let
        cells = l.readDir cellsFrom;
        allBlockNames = l.unique (
          l.flatten (
            l.mapAttrsToList (
              cellName: cellType:
                if cellType == "directory"
                then discoverBlocksFromCell (cellsFrom + "/${cellName}")
                else []
            )
            cells
          )
        );
      in
        allBlockNames
      else []
    );

    allBlockNames = l.unique (cellSpecificBlocks ++ globalBlocks);
  in
    builtins.addErrorContext "[ren] while discovering all blocks"
    l.map (name: {
      inherit name;
      type = name;
    })
    allBlockNames;

  discoveredBlocks =
    if hasAutodiscover
    then discoverAllBlocks
    else [];

  # merge the explicit and autodiscovered blocks (explicit taking precedence)
  allBlocks = explicitBlocks ++ discoveredBlocks;
  uniqueBlocks =
    l.foldl' (
      acc: block:
      # first occurence of name wins
        if l.any (b: b.name == block.name) acc
        then acc
        else acc ++ [block]
    ) []
    allBlocks;
in
  builtins.addErrorContext "[ren] while autodiscovering cell blocks"
  uniqueBlocks
