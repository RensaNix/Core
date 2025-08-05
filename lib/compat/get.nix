{select}: let
  get = t: p: let
    r = select t p;
    s = builtins.head (builtins.attrNames r);
  in
    r.${s};
in
  get
