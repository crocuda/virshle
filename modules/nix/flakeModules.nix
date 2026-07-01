{
  inputs,
  lib,
  ...
}: {
  flake-file.inputs = {
    flake-parts.url = lib.mkDefault "github:hercules-ci/flake-parts";
  };

  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];

  flake = {lib, ...}: rec {
    ## Do not work
    # flakeModules.default = inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ../../modules);

    ## Works
    # Taken from denful/den source code at "nix/flakeModule.nix".
    flakeModule = flakeModules.default;
    flakeModules.default = {...}: {
      imports = builtins.filter (p: lib.hasSuffix ".nix" p && !lib.hasInfix "/_" p) (
        lib.filesystem.listFilesRecursive ../../modules
      );
    };
  };
}
