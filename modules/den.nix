{ inputs, den, ... }:
{
  _module.args.__findFile = den.lib.__findFile;

  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "lepton" true)
  ];

  den.schema.user.classes = [ "homemanager" ];
}