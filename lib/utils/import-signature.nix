{l}: let
  deSystemize = let
    iteration = cutoff: system: fragment:
      if !(l.isAttrs fragment) || cutoff == 0
      then fragment
      else let
        recursed = l.mapAttrs (_: iteration (cutoff - 1) system) fragment;
      in
        if l.hasAttr "${system}" fragment
        then
          if l.isFunction fragment.${system}
          then recursed // {__functor = _: fragment.${system};}
          else recursed // fragment.${system}
        else recursed;
  in
    iteration 3;

  createImportSignature = cfg: system: cell: cells: additionalInputs: let
    self =
      cfg.inputs.self.sourceInfo
      // {
        rev = cfg.inputs.self.sourceInfo.rev or "not-a-commit";
      };
  in {
    inputs =
      (deSystemize system (cfg.inputs // additionalInputs))
      // {
        inherit self;
        cells = deSystemize system cells;
      };
    inherit cell system;
  };
in {
  inherit deSystemize createImportSignature;
}
