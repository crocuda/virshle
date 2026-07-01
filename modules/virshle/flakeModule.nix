{
  self,
  den,
  virshle,
  ...
}: {
  flake.flakeModules = rec {
    default = virshle;
    "virshle" = {};
  };

  virshle.aspects.default = {
    nixos = self.nixosModules.default;
  };
}
