{
  inputs,
  __findFile,
  ...
}:
let
  name = "charm";
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
      <lepton/compositor/niri>
    ];

    nixos =
      {
        imports = [
          inputs.disko.nixosModules.default
          ./_disko.nix
        ];

        # VM specific
        services.qemuGuest.enable = true;
      };
  };
}