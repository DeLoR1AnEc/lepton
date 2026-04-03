{
  inputs,
  __findFile,
  ...
}:
let
  name = "electron";
in
{
  den.hosts.x86_64-linux.${name} = {
    users.delorianec = {};
  };

  den.aspects.${name} = {
    includes = [
      # Preset
      <lepton/presets/desktop>

      # Host Specific
      <lepton/boot/secure>

      <lepton/preservation/system>
      <lepton/preservation/user>

      <lepton/compositor/niri>
    ];

    nixos =
      {
        imports = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480

          inputs.disko.nixosModules.default
          ./_disko.nix
        ];

        hardware.facter.reportPath = ./facter.json;

        fileSystems."/log".neededForBoot = true;
      };
  };
}