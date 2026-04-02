{ inputs, den, ... }:
{
  _module.args.__findFile = den.lib.__findFile;

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
          # <lepton/boot/secure>
          <lepton/boot/greeter>

          <lepton/zram>

          # --- Misc ---
          <lepton/networking>
          # <lepton/networking/ssh>
          <lepton/localization>

          # --- Apps ---
          <lepton/apps/core>
        ];
      };
    })
  ];
}