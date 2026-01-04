{
  l,
  utils,
  loader,
  autodiscover,
  blocks,
}: let
  inherit (utils) accumulate;
  inherit (loader) createCellLoader;

  build = {
    inputs,
    cellsFrom,
    cellBlocks ? [blocks.autodiscover],
    transformInputs ? system: i: i,
    ...
  } @ args: let
    # use passed systems if any, otherwise check if inputs contains systems and
    # import them, otherwise use defaults
    systems =
      args.systems or 
      (
        if builtins.hasAttr "systems" inputs
        then import inputs.systems
        else [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-linux"
          "aarch64-darwin"
        ]
      );

    cellBlocks' = autodiscover {inherit l cellsFrom cellBlocks;};

    cells = res.output;

    loadOutputFor = system: let
      loadCell = createCellLoader {
        inherit inputs system cells cellsFrom transformInputs;
        cellBlocks = cellBlocks';
      };

      cells' = l.mapAttrsToList (cell: type: cell) (l.readDir cellsFrom);
      res = accumulate (l.map loadCell cells');
    in
      builtins.addErrorContext "[ren] while loading output for ${system}" [
        {${system} = res.output;}
        {${system} = res.actions;}
        {
          name = system;
          value = res.init;
        }
      ];

    res = accumulate (l.map loadOutputFor systems);
  in
    builtins.addErrorContext "[ren] while building rensa output"
    res.output
    // {
      __ren = {
        __schema = "v0";
        cells = builtins.attrNames (l.readDir cellsFrom);
        init = l.listToAttrs res.init;
        actions = res.actions;
        cellsFrom = l.baseNameOf cellsFrom;
      };
    };

  buildWith = args: let
    inherit (builtins) head isAttrs length;
    inherit (l.lists) elemAt flatten take;

    g = p: l: r: v: let
      attrPath = take 2 p;
      v1 = !(isAttrs l && isAttrs r);
      v2 =
        if attrPath == ["__ren" "init"]
        then flatten v
        else head v;
    in [v1 v2];

    recursiveUpdateUntil = g: lhs: rhs: let
      f = attrPath:
        l.zipAttrsWith (
          n: values: let
            a = g here (elemAt values 1) (head values) values;
            here = attrPath ++ [n];
          in
            if length values == 1 || head a
            then elemAt a 1
            else f here values
        );
    in
      f [] [rhs lhs];

    recursiveUpdate = lhs: rhs:
      recursiveUpdateUntil g lhs rhs;
  in
    builtins.addErrorContext "[ren] while building rensa output (buildWith)" (
      build args
      // {
        __functor = l.flip recursiveUpdate;
      }
    );
in {
  inherit build buildWith;
}
