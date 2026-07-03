{
  inputs,
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

  virshle.aspects.vm = {
    nixos = {...}: {
      imports = [
        # self.nixosModules.vm
      ];
    };
  };

  flake = {
    lib,
    self,
    ...
  }: {
    nixosModules."vm" = {modulesPath, ...}: {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
        inputs.pipelight.nixosModules.pipelight-init
        inputs.disko.nixosModules.disko
        ../_nixos/vm
      ];
    };
    nixosConfigurations = let
      # Fix big disk image creation stuck at 'crng init done'.
      #
      # https://github.com/nix-community/nixos-generators/issues/443#issuecomment-3697547318
      #
      # Overlay to increase LKL (Linux Kernel Library) memory from 100M to 1024M
      # The cptofs tool uses LKL to run a kernel as a library for filesystem operations
      # during disk image creation. The default 100M causes OOM for large disk images.
      lklMemoryOverlay = final: prev: {
        lkl = prev.lkl.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              # Increase LKL kernel memory for large disk image builds
              substituteInPlace tools/lkl/cptofs.c \
                --replace-fail 'lkl_start_kernel("mem=100M")' 'lkl_start_kernel("mem=1024M")'
            '';
        });
      };
      mkVmConfigurations = list: (
        builtins.listToAttrs (
          builtins.map (args: {
            name = args.name;
            value = mkVmConfiguration args;
          })
          list
        )
      );
      # Creates a base vm nixosConfiguration.
      mkVmConfiguration = {
        name,
        size, # main disk size in GiB
        swap_size, # swapfile size in GiB
        imports ? [],
      }:
        self.inputs.nixpkgs.lib.nixosSystem {
          modules = [
            {
              imports = [self.nixosModules.vm] ++ imports;
              disko.devices.disk.main.imageSize = size;
              swapDevices = [
                {
                  device = "/var/lib/swapfile";
                  size = swap_size * 1024;
                }
              ];
            }
          ];
        };
    in
      mkVmConfigurations [
        {
          name = "xxs-test";
          size = "20G";
          swap_size = 1;
          imports = [
            ../_nixos/test.nix
          ];
        }
        {
          name = "xxs";
          size = "20G";
          swap_size = 1;
        }
        {
          name = "xs";
          size = "50G";
          swap_size = 1;
        }
        {
          name = "s";
          size = "80G";
          swap_size = 2;
        }
      ];
  };
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: let
    ## Create a package entry for each nixosConfiguration.
    ## You can build a disk image with: `nix run .#vm-<size>`.
    mkDiskImages = lib.mapAttrs' (nixosConfigurationName: nixosConfiguration: let
      # inherit (nixosConfiguration.config.nixpkgs.hostPlatform) system;
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
    packages = mkDiskImages self.nixosConfigurations;
  };
}
