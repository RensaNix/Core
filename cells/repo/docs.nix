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
        site_url = "https://rensa.projects.tf";
        repo_name = "rensa-nix/core";
        repo_url = "https://gitlab.com/rensa-nix/core";
        extra_css = ["style.css"];
        theme = {
          logo = "images/logo.svg";
          icon.repo = "simple/gitlab";
          favicon = "images/logo.svg";
        };
        nav = [
          {"Introduction" = "index.md";}
          {"Concepts" = "concepts.md";}
          {"Tutorial" = "tutorial.md";}
          {"API Reference" = "api.md";}
          {"Related Libraries" = "libraries.md";}
          {"Direnv Integration" = "direnv.md";}
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
          "admonition"
        ];
      };
    };
  }).packages
