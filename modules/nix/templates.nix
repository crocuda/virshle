{...}: {
  flake = rec {
    defaultTemplate = templates.default;
    templates = {
      default = {
        path = ../_templates/virshle-on-host;
        description = ''
          A minimal nixos configuration flake for hosts running virshle.
        '';
      };
      vm = {
        path = ../_templates/virshle-vm-compat;
        description = ''
          A minimal nixos configuration flake for virshle VMs.
        '';
      };
    };
  };
}
