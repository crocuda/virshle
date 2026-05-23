{
  den,
  inputs,
  ...
}: {
  imports = [
    # (inputs.flake-file.flakeModules.dendritic or {})
  ];

  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pipelight = {
      url = "github:pipelight/pipelight";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:denful/flake-file";
    den.url = "github:denful/den";
  };

  den.default.includes = [
    # den.batteries.inputs'
    # den.batteries.self'
  ];

  den.aspects.virshle = {
    nixos = {modulesPath, ...}: {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
        inputs.pipelight.nixosModules.pipelight-init
        inputs.disko.nixosModules.disko
        ./base
      ];
    };
  };
}
