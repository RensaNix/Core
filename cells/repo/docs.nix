{inputs, ...}: let
  inherit (inputs) doclib;
in
  (doclib.mkDocs {
    docs."default" = {
      base = "${inputs.self}";
      path = "${inputs.self}/docs";
      material = {
        enable = true;
        colors = {
          primary = "deep purple";
          accent = "purple";
        };
        umami = {
          enable = true;
          src = "https://analytics.tf/umami";
          siteId = "219a2bbe-e421-420c-a25c-e168b16d8b61";
          domains = ["rensa.projects.tf"];
        };
      };
      config = {
        site_name = "Rensa Core";
        repo_name = "rensa-nix/core";
        repo_url = "https://gitlab.com/rensa-nix/core";
        theme = {
          logo = "images/logo.png";
          icon.repo = "simple/gitlab";
          favicon = "images/favicon.png";
        };
        nav = [
          {"Introduction" = "index.md";}
        ];
        markdown_extensions = [
          {
            "pymdownx.highlight".pygments_lang_class = true;
          }
          "pymdownx.inlinehilite"
          "pymdownx.snippets"
          "pymdownx.superfences"
          "pymdownx.escapeall"
          "fenced_code"
        ];
      };
    };
  }).packages
