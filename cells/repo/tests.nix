{inputs, ...}: let
  inherit (inputs) pkgs ntlib rensa;
in {
  tests = ntlib.mkNixtest {
    modules = ntlib.autodiscover {dir = "${inputs.self}/tests";};
    args = {
      inherit pkgs ntlib rensa;
    };
  };
}
