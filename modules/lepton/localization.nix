{
  lepton.localization = {
    nixos =
      { pkgs, ...}:
      {
        time.timeZone = "Europe/Warsaw";

        i18n.extraLocales = [ "all" ];
        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
          LC_TIME = "en_GB.UTF-8";
          LC_COLLATE = "C";
          LC_PAPER = "pl_PL.UTF-8";
          LC_MEASUREMENT = "de_DE.UTF-8";
        };

        fonts.packages = with pkgs; [
          # icons
          material-design-icons
          font-awesome

          # nerd
          nerd-fonts.symbols-only
          nerd-fonts.fira-code
          nerd-fonts.jetbrains-mono
          nerd-fonts.iosevka

          # normal
          noto-fonts
          noto-fonts-color-emoji
          source-sans
          source-serif
          source-han-sans
          source-han-serif
          source-han-mono

          maple-mono.NF-CN-unhinted
        ];
      };
    };
}