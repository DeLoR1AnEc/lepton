#!/usr/bin/env nu

const UTILS = (path self ../../../utils.nu)
use $UTILS *

const FLAKE = "/etc/lepton"
const INSTALLER = "lepton-installer"
const SCRIPT_DIR = (path self .)

def main [--dry-run] {
  if $dry_run {
    print "Running in *dry* mode"
  }

  (gum style
    --foreground 212 --border-foreground 212 --border double
    --align center --width 50 --margin "1 2"
    "Lepton Installer")

  # ── Pick a host ────────────────────────────────────────────────────────────
  print ""
  let flake = if $dry_run { $SCRIPT_DIR | path join "../.." | path expand } else { $FLAKE }

  let hosts_raw = (nix flake show --json --no-write-lock-file $flake | complete)
  if $hosts_raw.exit_code != 0 {
    print $"Error reading flake: ($hosts_raw.stderr)"
    exit 1
  }

  let host = (
    $hosts_raw.stdout
    | from json
    | get nixosConfigurations
    | columns
    | where { |h| $h != $INSTALLER }
    | str join "\n"
    | gum choose --header "Select host to install:"
  )

  # ── Pick a disk ────────────────────────────────────────────────────────────
  print ""
  (gum style --foreground 99 "Available disks:")
  lsblk -d -o NAME,SIZE,MODEL | grep -v loop

  let disk = (
    lsblk -d -o NAME --noheadings
    | lines
    | where { |l| ($l | str trim) != "" and not ($l | str contains "loop") }
    | each { |l| $"/dev/($l | str trim)" }
    | str join "\n"
    | gum choose --header "Select target disk (ALL DATA WILL BE ERASED):"
  )

  # ── Facter ─────────────────────────────────────────────────────────────────
  print ""
  let do_facter = try { gum confirm $"Regenerate facter.json for ($host)?"; true } catch { false }
  if $do_facter {
    (gum style --foreground 212 "Generating facter.json…")
    if $dry_run {
      print $"[dry-run] would run: nixos-facter -o ($flake)/modules/hosts/($host)/facter.json"
    } else {
      let result = (
        sudo nix run github:nix-community/nixos-facter -- -o $"($flake)/modules/hosts/($host)/facter.json"
        | complete
      )
      if $result.exit_code != 0 {
        print "Warning: facter generation failed, using committed facter.json"
      }
    }
  }

  # ── Confirm ────────────────────────────────────────────────────────────────
  print ""
  let confirmed = try { gum confirm $"Install ($host) onto ($disk)? This will ERASE the disk."; true } catch { false }
  if not $confirmed {
    print "Aborted."
    exit 1
  }

  # ── Install ────────────────────────────────────────────────────────────────
  print ""
  (gum style --foreground 212 $"Installing ($host) onto ($disk)…")
  if $dry_run {
    print $"[dry-run] would run: disko --flake ($flake)#($host) --disk main ($disk)"
    print $"[dry-run] would run: nixos-install --flake ($flake)#($host)"
    print $"[dry-run] would run: cp -r ($flake) /mnt/persistent/lepton-flake"
  } else {
    print $"Installing '($host)'..."

    print "Running disko..."
    sudo nix run github:nix-community/disko -- --mode disko --flake $"($FLAKE)#($host)" --disk main $disk

    print "Running nixos-install..."
    sudo nixos-install --flake $"($FLAKE)#($host)" --no-root-passwd

    print "Copying flake to target..."
    sudo cp -r $FLAKE /mnt/persistent/lepton
  }

  print ""
  (gum style
    --foreground 46 --border-foreground 46 --border rounded
    --align center --width 50 --margin "1 2"
    "Done! Remove the USB and reboot.")
}