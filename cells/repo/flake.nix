{
  inputs = {
    devshell.url = "gitlab:rensa-nix/devshell?dir=lib";
  };

  outputs = i:
    i
    // {
      dslib = i.devshell.lib {inherit (i.parent) pkgs;};
    };
}
