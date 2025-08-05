# Adapted from https://github.com/divnix/call-flake
# see ./call-flake-LICENSE.md for the LICENSE
ref: inputOverrides: let
  inherit (builtins) fetchTree removeAttrs;

  dir = ref.dir or "";
  src =
    if builtins.isPath ref || builtins.isString ref
    then {outPath = ref;}
    else
      builtins.fetchTree (
        if builtins.isAttrs ref
        then builtins.removeAttrs ref ["dir"]
        else ref
      );

  lockFileStr = let
    rootlock = "${src}/flake.lock";
    sublock = "${src}/${dir}/flake.lock";
  in
    if dir == "" && builtins.pathExists rootlock
    then builtins.readFile rootlock
    else if dir != "" && builtins.pathExists sublock
    then builtins.readFile sublock
    else
      builtins.toJSON {
        nodes.root = {};
        root = "root";
      };

  overrides =
    {
      root = {
        sourceInfo = src;
        subdir = dir;
        inputs = inputOverrides.root or {};
      };
    }
    // (
      builtins.mapAttrs
      (key: inputs: {inherit inputs;})
      (builtins.removeAttrs inputOverrides ["root"])
    );

  lockFile = builtins.fromJSON lockFileStr;

  # Resolve a input spec into a node name. An input spec is
  # either a node name, or a 'follows' path from the root
  # node.
  resolveInput = inputSpec:
    if builtins.isList inputSpec
    then getInputByPath lockFile.root inputSpec
    else inputSpec;

  # Follow an input path (e.g. ["dwarffs" "nixpkgs"]) from the
  # root node, returning the final node.
  getInputByPath = nodeName: path:
    if path == []
    then nodeName
    else
      getInputByPath
      (resolveInput lockFile.nodes.${nodeName}.inputs.${builtins.head path})
      (builtins.tail path);

  allNodes =
    builtins.mapAttrs (
      key: node: let
        sourceInfo =
          if overrides ? ${key} && overrides.${key} ? "sourceInfo"
          then overrides.${key}.sourceInfo
          else fetchTree (node.info or {} // removeAttrs node.locked ["dir"]);

        subdir = overrides.${key}.dir or node.locked.dir or "";

        outPath =
          sourceInfo
          + (
            (
              if subdir == ""
              then ""
              else "/"
            )
            + subdir
          );

        flake = import (outPath + "/flake.nix");

        inputs =
          builtins.mapAttrs
          (inputName: inputSpec: allNodes.${resolveInput inputSpec})
          (node.inputs or {});

        outputs = flake.outputs (inputs // {self = result;} // (overrides.${key}.inputs or {}));

        result =
          outputs
          # We add the sourceInfo attribute for its metadata, as they are
          # relevant metadata for the flake. However, the outPath of the
          # sourceInfo does not necessarily match the outPath of the flake,
          # as the flake may be in a subdirectory of a source.
          # This is shadowed in the next //
          // sourceInfo
          // {
            # This shadows the sourceInfo.outPath
            inherit outPath inputs outputs sourceInfo;
            _type = "flake";
          };
      in
        if node.flake or true
        then assert builtins.isFunction flake.outputs; result
        else sourceInfo
    )
    lockFile.nodes;
in
  allNodes.${lockFile.root}
