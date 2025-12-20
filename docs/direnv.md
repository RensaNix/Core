# Direnv Integration

Rensa provides a custom `direnv` integration to make your development experience smoother.
It allows you to automatically load development shells defined in your cells.

!!! note

    This integration is based on [nix-direnv](https://github.com/nix-community/nix-direnv)
    but has been improved and optimized specifically for Rensa usage.

## Setup

1. **Create `.envrc`**: Add the following to your `.envrc` file:

    ```bash
    source $(fetchurl https://gitlab.com/rensa-nix/direnv/-/raw/v0.3.0/direnvrc "sha256-u7+KEz684NnIZ+Vh5x5qLrt8rKdnUNexewBoeTcEVHQ=")
    use ren //backend/devShells/default
    ```

    This will automatically load the devShell `default` defined in `cells/backend/devShells.nix`.

1. **Allow Direnv**: Run `direnv allow` to trust the configuration.

## Updating

To update the `direnvrc` to the latest version (or a specific version), you can use `direnv fetchurl`.

1. **Run fetchurl**:

    ```bash
    direnv fetchurl https://gitlab.com/rensa-nix/direnv/-/raw/v0.3.0/direnvrc
    ```

    *Note: Replace `v0.3.0` with the desired version tag.*

1. **Update `.envrc`**: The command above will output a new hash.
    Replace the previous version and hash in your `.envrc` with the new values.
