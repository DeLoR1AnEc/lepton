{ inputs, den, ... }:
{
  _module.args.__findFile = den.lib.__findFile;

  den.schema.user = { user, lib, ... }: {
    config.classes = lib.mkDefault [ "homeManager" ];
  };

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

        homeManager = {
          programs.home-manager.enable = true;
          home = {
            sessionPath = [ "$HOME/.local/bin" ];
            sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
            stateVersion = "22.05";
          };
        };
      };
    })
  ];
}