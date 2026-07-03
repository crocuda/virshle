{...}: {
  imports = [
    ./nix.nix
    ./hardware-configuration.nix
    ./disko.nix
    ./networking.nix
    ./misc.nix
  ];
}
