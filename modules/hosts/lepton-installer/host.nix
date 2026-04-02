{
  inputs,
  __findFile,
  ...
}:
let
  name = "lepton-installer";
in
{
  den.hosts.x86_64-linux.${name} = { };

  den.aspects.${name} =
    {
      includes = [
        <lepton/networking>
        <lepton/localization>
      ];

      nixos =
        { pkgs, lib, ... }:
        {
          imports = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];

          # ── Bake the flake into the ISO ──────────────────────────────────────
          environment.etc."lepton" = {
            source = inputs.self;
          };

          # ── Packages ─────────────────────────────────────────────────────────
          environment.systemPackages = with pkgs; [
            inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
            nushell
            just
            gum
            jq
            git
            parted
            pciutils
            btrfs-progs
          ];

          # ── Auto-login + hint ─────────────────────────────────────────────────
          services.getty.autologinUser = lib.mkForce "root";
          environment.variables.JUST_JUSTFILE = "/etc/lepton/Justfile";
          environment.etc."motd".text = ''
            echo " =========================="
            echo "  Run: just install-lepton "
            echo " =========================="
          '';

          image.baseName = lib.mkForce "${name}";
        };
    };
}