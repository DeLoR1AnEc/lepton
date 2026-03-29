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
          # --- Den ---
          <den/define-user>

          # --- Boot ---
          <lepton/boot>
          # <lepton/secure>
          # <lepton/greeter>

          # --- Zram ---
          <lepton/zram>

          # --- Misc ---
          <lepton/networking>
          # <lepton/networking/ssh>
          <lepton/localization>
          # <lepton/localization/fonts>
        ];
      };
    })
  ];
}