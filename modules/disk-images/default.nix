{
  inputs,
  den,
  ...
}: {
  flake.nixosModules."vm" = {modulesPath, ...}: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.pipelight.nixosModules.pipelight-init
      inputs.disko.nixosModules.disko
      ./_base
    ];
  };
  flake.nixosModules."vm-test" = {modulesPath, ...}: {
    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      inputs.pipelight.nixosModules.pipelight-init
      inputs.disko.nixosModules.disko
      ./_base
      ./_base/test.nix
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
