{
  lepton,
  inputs,
  lib,
  den,
  __findFile,
  ...
}:
{
  lepton.compositor._.niri =
    { host, user }:
    {
      includes = [
        <lepton/wayland>
      ];

      nixos =
        { config, pkgs, ... }:
        {
          imports = [ inputs.noctalia.nixosModules.noctalia ];
          environment = {
            variables.AWT_TOOLKIT = "MToolkit";
            variable._JAVA_AWT_WM_NONREPARENTING = 1;
            systemPackages = with pkgs; [
              xwayland-satellite
            ];
          };

          programs.niri.enable = true;
          programs.niri.package = pkgs.niri;
        };

      homeManager =
        { config, pkgs, ... }:
        {
          imports = [
            inputs.niri.homeModules.config
            inputs.noctalia.homeModules.noctalia
          ];

          programs.niri = {
            settings = {
              spawn-at-startup = [
                { command = [ "noctalia-shell" ]; }
              ];
            };
          };
        };
    };
}