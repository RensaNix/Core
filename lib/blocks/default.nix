{
  simple = name: {
    inherit name;
    type = name;
  };
  dynamic = name: {
    inherit name;
    type = name;
    cli = true;
    actions = args: {};
    # TODO: dynamic actions
  };
  autodiscover = {
    name = "__autodiscover";
    type = "__autodiscover";
    _functor = self: cell:
      self
      // {
        inherit cell;
      };
  };
}
