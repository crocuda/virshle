{
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.pipelight.nixosModules.pipelight-init
    inputs.disko.nixosModules.disko
    ./base
  ];
}
