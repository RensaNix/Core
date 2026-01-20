# Debugging

## Error Context

To help with debugging, Rensa uses Nix's `builtins.addErrorContext` to add context
about where an error is happening.

Use the following command to get just these logs from Rensa and please include that (or the whole stacktrace) in any issues or bug reports :)

```sh
nix ... --show-trace 2> >(grep "… \[ren\]")
```

## Trace Verbose

There are also some `traceVerbose` calls in Rensa, so to debug non-failing executions
just run Nix with the `--trace-verbose` flag.

The output could look like this (example with this repo's flake):

```sh
trace: [ren] loading cell block ci, type ci, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-darwin
trace: [ren] loading cell block devShells, type devShells, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-darwin
trace: [ren] loading cell block docs, type docs, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-darwin
trace: [ren] loading cell block soonix, type soonix, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-darwin
trace: [ren] loading cell block ci, type ci, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-linux
trace: [ren] loading cell block devShells, type devShells, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-linux
trace: [ren] loading cell block docs, type docs, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-linux
trace: [ren] loading cell block soonix, type soonix, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system aarch64-linux
trace: [ren] loading cell block ci, type ci, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-darwin
trace: [ren] loading cell block devShells, type devShells, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-darwin
trace: [ren] loading cell block docs, type docs, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-darwin
trace: [ren] loading cell block soonix, type soonix, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-darwin
trace: [ren] loading cell block ci, type ci, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-linux
trace: [ren] loading cell block devShells, type devShells, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-linux
trace: [ren] loading cell block docs, type docs, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-linux
trace: [ren] loading cell block soonix, type soonix, from cell /nix/store/7acz6q9360fkg0x187yx43d1vwpv850l-cells/repo, for system x86_64-linux
```
