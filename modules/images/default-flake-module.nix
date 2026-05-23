{den, ...}: {
  den.aspects.virshle.vm = {
    nixos = {...}: {
      imports = [./default.nix];
    };
  };
}
