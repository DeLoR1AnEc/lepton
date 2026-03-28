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
          # den
          <den/define-user>

          # lepton
          <lepton/boot>
          <lepton/boot/secure>
          <lepton/boot/greeter>

          <lepton/zram>
        ];

        nixos.system.stateVersion = "22.05";
      };
    })
  ];
}