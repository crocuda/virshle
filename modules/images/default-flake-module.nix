{den, ...}: {
  den.aspects.virshle = {
    nixos = {...}: {
      imports = [./default.nix];
    };
  };
}
