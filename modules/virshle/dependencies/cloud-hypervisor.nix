{...}: {
  flake.nixosModules."virshle" = {
    lib,
    config,
    pkgs,
    ...
  }: {
    config = lib.mkIf config.services."virshle".enable {
      systemd.tmpfiles.rules = let
        cloud-hypervisor-fw = pkgs.fetchurl {
          url = "https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/0.5.0/hypervisor-fw";
          # hash = lib.fakeHash;
          hash = "sha256-Sgoel3No9rFdIZiiFr3t+aNQv15a4H4p5pU3PsFq2Vg=";
        };
        cloud-hypervisor-ovmf = pkgs.fetchurl {
          # url = "https://github.com/cloud-hypervisor/edk2/releases/download/ch-6624aa331f/CLOUDHV.fd";
          url = "https://github.com/cloud-hypervisor/edk2/releases/download/ch-a54f262b09/CLOUDHV.fd";
          # hash = lib.fakeHash;
          hash = "sha256-BiTAbF0Hy47+OIBokM5wdsQcCQLy/NWyN28QcDPjIis=";
        };
      in [
        " L+ /run/cloud-hypervisor/hypervisor-fw - - - - ${cloud-hypervisor-fw}"
        " L+ /run/cloud-hypervisor/CLOUDVH.fd - - - - ${cloud-hypervisor-ovmf}"
      ];

      environment.systemPackages = with pkgs; [
        # VMMs
        cloud-hypervisor #v0.50.2

        # Efi related?
        # OVMF-cloud-hypervisor
        # OVMF
      ];
    };
  };
}
