{
  inputs,
  den,
  ...
}: {
  # Create "my" namespace (exported to flake outputs)
  imports = [
    (inputs.den.namespace "virshle" true)
  ];
  _module.args.__findFile = den.lib.__findFile;
}
