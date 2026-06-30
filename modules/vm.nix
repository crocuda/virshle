{self, ...}: {
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    ## Create a package entry for each nixosConfiguration.
    ## You can build a disk image with: `nix run .#vm-<size>`.
    mkDiskImages = lib.mapAttrs' (nixosConfigurationName: nixosConfiguration: let
      inherit (nixosConfiguration.config.nixpkgs.hostPlatform) system;
      hostConfig = nixosConfiguration.config;
    in {
      name = "vm-${nixosConfigurationName}";
      value = pkgs.writeShellApplication {
        name = "vm-${nixosConfigurationName}";
        text = ''
          ${hostConfig.system.build.vm}/bin/run-${hostConfig.networking.hostName}-vm "$@"
        '';
      };
    });
  in {
    packages = self.nixosConfigurations;
  };
}
