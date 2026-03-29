{
  inputs,
  __findFile,
  ...
}:
let
  name = "tau";
  compositor = "niri";
in
{
  den.hosts.x86_64-linux.${name} = {
    users.delorianec = {};
  };
  den.aspects.${name} = {
    includes = [
      <lepton/preservation/system>
      <lepton/preservation/user>

      <lepton/presets/desktop>
    ];

    nixos =
      {
        imports = with inputs; [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          inputs.disko.nixosModules.default

          ./_disko.nix
        ];

        hardware.facter.reportPath = ./facter.json;

        fileSystems."/persistent".neededForBoot = true;
        fileSystems."/log".neededForBoot = true;
      };
  };
}