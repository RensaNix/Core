{
  inputs = {
    devshell.url = "gitlab:rensa-nix/devshell?dir=lib";
    nixmkdocs.url = "gitlab:TECHNOFAB/nixmkdocs?dir=lib";
  };

  outputs = i:
    i
    // {
      dslib = i.devshell.lib {inherit (i.parent) pkgs;};
      doclib = i.nixmkdocs.lib {inherit (i.parent) pkgs;};
    };
}
