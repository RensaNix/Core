{l}: let
  filter = pred: t: p: let
    multiplePaths = l.isList (l.elemAt p 0);
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
      then builtins.abort "[ren] filter: Path ${toString path} not found in any targets."
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
  in
    if multiplePaths
    then l.foldl' l.recursiveUpdate {} (map (path: hoist path) p)
    else hoist p;
in
  filter
