{
  l,
  utils,
  paths,
  callFlake,
}: let
  inherit (utils) optionalLoad createImportSignature;

  createCellBlockLoader = {
    inputs,
    system,
    cell,
    cells,
    transformInputs,
  }: let
    importSignatureFor = createImportSignature {inherit inputs transformInputs;};

    loadCellBlock = cellName: cellP: cellBlock: let
      blockP = paths.cellBlockPath cellP cellBlock;
      isFile = l.pathExists blockP.file;
      isDir = l.pathExists blockP.dir;

      signature = let
        cell = cell // {__cr = [cellName cellBlock.name];};
        additionalInputs =
          if l.pathExists cellP.flake
          then
            (callFlake (builtins.dirOf cellP.flake) {
              root = {
                parent = transformInputs system inputs;
                inherit system;
              };
            }).outputs
          else {};
      in
        importSignatureFor system cell cells additionalInputs;

      import' = importPath: let
        block = import importPath;
      in
        if l.typeOf block == "set"
        then block
        else block signature;

      importPaths =
        if isFile
        then {
          displayPath = blockP.file';
          importPath = blockP.file;
        }
        else if isDir
        then {
          displayPath = blockP.dir';
          importPath = blockP.dir;
        }
        else throw "Neither ${blockP.file} nor ${blockP.dir} exist, this shouldn't happen!";

      imported = import' importPaths.importPath;
      isAttrs = builtins.isAttrs imported;

      cellOptions = imported.__cell or {};
      targetOverrides = cellOptions.targets or null;

      extracted = l.traceVerbose "[ren] extracting ${importPaths.displayPath}. cli=${toString (cellBlock.cli or false)}" (
        l.optionalAttrs (cellBlock.cli or false)
        (l.mapAttrs (name: target: let
            fragment = ''"${system}"."${cellName}"."${cellBlock.name}"."${name}"'';
            actions' =
              if cellBlock ? actions
              then
                l.listToAttrs (
                  map (a: l.nameValuePair a.name a)
                  (cellBlock.actions {
                    inherit target fragment inputs system;
                    fragmentRelPath = "${cellName}/${cellBlock.name}/${name}";
                  })
                )
              else {};
          in {
            init = l.traceVerbose "[ren] loading, system=${system} path=${importPaths.importPath} name=${name}" {
              inherit name;
              actions =
                l.mapAttrsToList (name: a: {
                  inherit name;
                  inherit (a) description;
                  requiresArgs =
                    if (target ? meta && target.meta ? requiresArgs)
                    then (builtins.elem name target.meta.requiresArgs)
                    else false;
                })
                actions';
            };
            actions = l.mapAttrs (_: a: a.command) actions';
          })
          (
            if targetOverrides != null
            then targetOverrides
            else imported
          ))
      );
    in
      optionalLoad (isFile || isDir) (
        assert l.assertMsg isAttrs "cell block does not return an attrset: ${importPaths.displayPath}";
          l.traceVerbose "[ren] loading cell block ${cellBlock.name}, type ${cellBlock.type}, from cell ${cellP}"
          [
            {${cellBlock.name} = imported;}
            {${cellBlock.name} = l.mapAttrs (_: set: set.actions) extracted;}
            ({
                cellBlock = cellBlock.name;
                blockType = cellBlock.type;
                targets = l.mapAttrsToList (_: set: set.init) extracted;
              }
              // (l.optionalAttrs (l.pathExists blockP.readmeDir) {readme = blockP.readmeDir;})
              // (l.optionalAttrs (l.pathExists blockP.readme) {inherit (blockP) readme;}))
          ]
      );
  in
    loadCellBlock;

  createCellLoader = {
    inputs,
    system,
    cells,
    cellsFrom,
    cellBlocks,
    transformInputs,
  }: let
    inherit (utils) unique accumulate;

    loadCell = cellName: let
      cell = res.output;
      cellP = paths.cellPath cellsFrom cellName;
      cellBlocks' = (unique cellBlocks).result;
      loadCellBlock = createCellBlockLoader {inherit inputs system cells cell transformInputs;};
      res = accumulate (l.map (loadCellBlock cellName cellP) cellBlocks');
    in [
      {${cellName} = res.output;}
      {${cellName} = res.actions;}
      ({
          cell = cellName;
          cellBlocks = res.init;
        }
        // (l.optionalAttrs (l.pathExists cellP.readme) {inherit (cellP) readme;}))
    ];
  in
    loadCell;
in {
  inherit createCellLoader createCellBlockLoader;
}
