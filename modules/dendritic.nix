{
  inputs,
  lib,
  ...
}: {
  flake = {
    # description = "Virshle - Manage VM with TOML";
  };
  imports = [
    (inputs.flake-parts.flakeModules.flakeModules or {})
    (inputs.flake-file.flakeModules.dendritic or {})
    (inputs.den.flakeModules.dendritic or {})
  ];
  flake-file.inputs = {
    ###################################
    ## Dendritic
    flake-file.url = lib.mkDefault "github:vic/flake-file";
    flake-parts.url = lib.mkDefault "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    den.url = "github:denful/den";

    ###################################
    ## NixOs pkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };
}
