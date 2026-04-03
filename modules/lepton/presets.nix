{ den, __findFile, ... }:
{
  lepton.presets._ = {
    desktop = den.lib.parametric.atLeast {
      includes = [
        # --- Den ----
        <den/define-user>

        # --- Home ---
        <lepton/home>

        # --- Boot ---
        <lepton/boot>
        # <lepton/boot/secure>
        <lepton/boot/greeter>

        <lepton/zram>

        # --- Misc ---
        <lepton/networking>
        # <lepton/networking/ssh>

        <lepton/localization>

        <lepton/secrets>

        # --- Apps ---
        <lepton/apps/core>
        <lepton/apps/shells>
      ];
    };
  };
}