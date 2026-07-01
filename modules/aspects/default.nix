{self, ...}: {
  virshle.aspects = rec {
    default = virshle;
    virshle.nixos = self.nixosModules.default;
  };
}
