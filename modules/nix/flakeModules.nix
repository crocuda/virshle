{inputs, ...}: {
  flake = {lib, ...}: {
    ## Do not work
    # flakeModules.default = inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ../../modules);

    ## Works
    # Taken from denful/den source code at "nix/flakeModule.nix".
    flakeModules.default = {...}: {
      imports = builtins.filter (p: lib.hasSuffix ".nix" p && !lib.hasInfix "/_" p) (
        lib.filesystem.listFilesRecursive ../../modules
      );
    };
  };
}
