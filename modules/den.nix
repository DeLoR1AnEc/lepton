{ inputs, den, ... }:
{
  _module.args.__findFile = den.lib.__findFile;

  systems = [ "x86_64-linux" ];
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "lepton" true)

    ({ __findFile, ... }: {
      den.default = {
        includes = [
          #<den/home-manager>
          <den/define-user>
        ];
      };
    })
  ];
}