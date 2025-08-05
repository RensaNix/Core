{l}: rec {
  filter = import ./filter.nix {inherit l;};
  select = import ./select.nix {inherit filter;};
  get = import ./get.nix {inherit select;};
}
