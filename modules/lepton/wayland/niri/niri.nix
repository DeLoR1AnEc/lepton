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
          imports
        };
    };
}