{
  inputs,
  den,
  self,
  ...
}: {
  flake-file.inputs = {
    pipelight.url = "github:pipelight/pipelight";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  flake.nixosModules."vm" = {modulesPath, ...}: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.pipelight.nixosModules.pipelight-init
      inputs.disko.nixosModules.disko
      ./_base
    ];
  };

  virshle.vm = {
    nixos = {...}: {
      imports = [
        self.nixosModules."vm"
      ];
    };
  };
}
