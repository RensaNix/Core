# Related Libraries

Rensa has a growing ecosystem of compatible libraries designed to work seamlessly with its cell structure.
These libraries typically expose a `lib` output that accepts `pkgs` as an argument.

## Available Libraries

Here are some common libraries you might want to use:

- [**Rensa Devshell**](https://devshell.rensa.projects.tf): _Minimal devshell implementation using Modules._
- [**Rensa Devtools**](https://devtools.rensa.projects.tf): _Utils and dev tools for the Rensa ecosystem._
- [**Rensa Utils**](https://utils.rensa.projects.tf): _Utilities for NixOS/darwin systems, home & disko configurations etc._
- [**Nix-GitLab-CI**](https://nix-gitlab-ci.projects.tf): _Allows (advanced) configuration of GitLab CI using Nix._
- [**Nixible**](https://nixible.projects.tf): _Ansible but with Nix._
- [**Tofunix**](https://tofunix.projects.tf): _Combining Nix and Terraform for reproducibility and developer experience._
- [**Nixlets**](https://nixlets.projects.tf): _Nixlets - like Helm Charts or Grafana Tanka but instead using Nix._
- [**Nixtest**](https://nixtest.projects.tf): _Test runner for Nix code._
- [**Soonix**](https://soonix.projects.tf): _Auto generated project files from Nix code, with gitignore handling and many generators._
- [**NixMkDocs**](https://nix-mkdocs.projects.tf): _Nix library for easy mkdocs integration into projects._
- [**Torikae**](https://torikae.projects.tf): _Simple CLI to replace versions in files._

## Usage Pattern

When using these libraries within a Cell Flake, you can instantiate them using the `pkgs` passed down from the parent flake.
This follows the "Single Instantiation" best practice.

### Example: `cells/mycell/flake.nix`

```nix
{
  inputs = {
    # Add the library to your inputs
    devshell.url = "gitlab:rensa-nix/devshell?dir=lib";
    
    # ... other inputs
  };

  outputs = i:
    i
    // {
      # Instantiate the library using the parent's pkgs
      dslib = i.devshell.lib { inherit (i.parent) pkgs; };
    };
}
```

Now you can use `inputs.dslib` in your blocks!
