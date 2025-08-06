{
  inputs = {
    devshell.url = "gitlab:rensa-nix/devshell?dir=lib";
  };

  outputs = i:
    i
    // rec {
      pkgs = import i.parent.nixpkgs {
        inherit (i) system;
      };
      devshellLib = i.devshell.lib {inherit pkgs;};
    };
}
