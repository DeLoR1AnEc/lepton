# Bootable NixOS ISO with lepton baked in.
#
# Build:
#   nix build .#flake.nixosConfigurations.installer.config.system.build.isoImage
#
# Flash:
#   dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress && sync
#
# On boot, run:  lepton-install

{ inputs, ... }:

let
  installerSystem = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

      ({ pkgs, lib, ... }: {

        # ── Bake the flake into the ISO ──────────────────────────────────────
        environment.etc."lepton" = {
          source = inputs.self;
        };

        # ── Packages ─────────────────────────────────────────────────────────
        environment.systemPackages = with pkgs; [
          inputs.disko.packages.${pkgs.system}.disko
          nushell
          just
          gum
          jq
          git
          parted
          lshw
          pciutils
          btrfs-progs

          (writeShellApplication {
            name = "lepton-install";
            runtimeInputs = [ gum jq lshw just nushell ];
            text = ''
              set -euo pipefail

              FLAKE=/etc/lepton

              gum style \
                --foreground 212 --border-foreground 212 --border double \
                --align center --width 50 --margin "1 2" \
                "lepton installer"

              # ── Pick a host ────────────────────────────────────────────────
              # `nix flake show --json` dumps the flake outputs as JSON.
              # jq plucks the keys of nixosConfigurations (your host names),
              # grep drops the installer itself from the list,
              # then gum choose renders an interactive menu and prints the
              # selection to stdout, which we capture into $HOST.
              echo ""
              HOSTS=$(nix flake show --json "$FLAKE" 2>/dev/null \
                | jq -r '.nixosConfigurations | keys[]' \
                | grep -v '^installer$')

              HOST=$(echo "$HOSTS" | gum choose --header "Select host to install:")

              # ── Pick a disk ────────────────────────────────────────────────
              # lsblk lists physical disks (-d = no partitions).
              # awk prepends /dev/ to the NAME column to get a usable path.
              # Again gum choose turns that list into an interactive menu,
              # result goes into $DISK.
              echo ""
              gum style --foreground 99 "Available disks:"
              lsblk -d -o NAME,SIZE,MODEL | grep -v loop

              DISK=$(lsblk -d -o NAME,MODEL --noheadings \
                | grep -v loop \
                | awk '{print "/dev/" $1}' \
                | gum choose --header "Select target disk (ALL DATA WILL BE ERASED):")

              # ── Facter ────────────────────────────────────────────────────
              # gum confirm prints a yes/no prompt and exits 0 for yes, 1 for
              # no. The || true stops set -e from aborting on a "no" answer.
              echo ""
              if gum confirm "Regenerate facter.json for $HOST on this machine?"; then
                gum style --foreground 212 "Generating facter.json…"
                just -f "$FLAKE/Justfile" facter "$HOST" \
                  || echo "Warning: facter generation failed, using committed facter.json"
              fi

              # ── Confirm ───────────────────────────────────────────────────
              echo ""
              gum confirm \
                "Install $HOST onto $DISK? This will ERASE the disk." \
                || { echo "Aborted."; exit 1; }

              # ── Install ───────────────────────────────────────────────────
              echo ""
              gum style --foreground 212 "Installing $HOST onto $DISK…"
              just -f "$FLAKE/Justfile" install "$HOST" "$DISK"

              echo ""
              gum style \
                --foreground 46 --border-foreground 46 --border rounded \
                --align center --width 50 --margin "1 2" \
                "Done! Remove the USB and reboot."
            '';
          })
        ];

        # ── Nix ──────────────────────────────────────────────────────────────
        nix.settings = {
          experimental-features = [ "nix-command" "flakes" ];
          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org"
            "https://chaotic-nyx.cachix.org/"
            "https://noctalia.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };

        # ── Auto-login + hint ─────────────────────────────────────────────────
        services.getty.autologinUser = lib.mkForce "root";
        environment.loginShellInit = ''
          if [ "$(tty)" = "/dev/tty1" ]; then
            echo ""
            echo "  Run: lepton-install"
            echo ""
          fi
        '';

        isoImage.isoName = lib.mkForce "lepton-installer.iso";
        isoImage.squashfsCompression = "zstd -Xcompression-level 6";
      })
    ];
  };
in

{
  flake.nixosConfigurations.installer = installerSystem;
}