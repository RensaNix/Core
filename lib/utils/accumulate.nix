{l}: let
  unique =
    l.foldl' (
      acc: e:
        if l.elem e.name acc.visited
        then acc
        else {
          visited = acc.visited ++ [e.name];
          result = acc.result ++ [e];
        }
    ) {
      visited = [];
      result = [];
    };

  accumulate =
    l.foldl' (
      acc: new: let
        first = l.head new;
        cdr = l.tail new;
        second = l.head cdr;
        cdr' = l.tail cdr;
        third = l.head cdr';
      in
        (
          if first == null
          then {inherit (acc) output;}
          else {output = acc.output // first;}
        )
        // (
          if second == null
          then {inherit (acc) actions;}
          else {actions = acc.actions // second;}
        )
        // (
          if third == null
          then {inherit (acc) init;}
          else {init = acc.init ++ [third];}
        )
    ) {
      output = {};
      actions = {};
      init = [];
    };

  optionalLoad = cond: elem:
    if cond
    then elem
    else [
      null # empty output
      null # empty action
      null # empty init
    ];
in {
  inherit unique accumulate optionalLoad;
}
