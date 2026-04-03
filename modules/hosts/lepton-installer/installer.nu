#!/usr/bin/env nu

const FLAKE_PATH = (path self .)

def main [--dry-run] {
  if $dry_run {
    (gum style --foreground 214 "Running in *dry* mode")
  }

  (gum style
    --foreground 212 --border-foreground 212 --border double
    --align center --width 50 --margin "1 2"
    "Lepton Installer")

  if $dry_run {
    (gum style --foreground 214 $"[dry-run] would run: ^cp -rL --no-preserve=mode /etc/lepton /tmp/lepton")
  } else {
    ^cp -rL --no-preserve=mode /etc/lepton /tmp/lepton
  }

  let flake = if $dry_run { $FLAKE_PATH | path join "../../.." | path expand } else { "/tmp/lepton" }

  # ── Pick a host ────────────────────────────────────────────────────────────
  let hosts_raw = (nix flake show --json --no-write-lock-file $flake | complete)
  if $hosts_raw.exit_code != 0 {
    (gum style --foreground 196 $"Error reading flake: ($hosts_raw.stderr)")
    exit 1
  }

  let host = (
    $hosts_raw.stdout
    | from json
    | get nixosConfigurations
    | columns
    | where { |h| $h != "lepton-installer" }
    | str join "\n"
    | gum choose --header "Select host to install:"
  )

  # ── Pick a disk ────────────────────────────────────────────────────────────
  let disko_file = $"($flake)/modules/hosts/($host)/_disko.nix"
  let needs_disk = (open $disko_file | str contains 'device = "";')

  let disk = if $needs_disk {
    (gum style --foreground 99 "Available disks:")
    lsblk -d -o NAME,SIZE,MODEL | grep -v loop

    (
      lsblk -d -o NAME --noheadings
      | lines
      | where { |l| ($l | str trim) != "" and not ($l | str contains "loop") }
      | each { |l| $"/dev/($l | str trim)" }
      | str join "\n"
      | gum choose --header "Select target disk (ALL DATA WILL BE ERASED):"
    )
  } else {
    ""
  }

#  if $needs_disk {
#    (gum style --foreground 212 "Writing disk to config…")
#    if $dry_run {
#      (gum style --foreground 214 $"[dry-run] would run: sed -i \"s|device = \"\";|device = \"($disk)\";|\" ($disko_file)")
#    } else {
#      sed -i $"s|device = \"\";|device = \"($disk)\";|" $disko_file
#    }
#  }

  # ── Facter ─────────────────────────────────────────────────────────────────
  let do_facter = try { gum confirm $"Regenerate facter.json for ($host)?"; true } catch { false }
  if $do_facter {
    (gum style --foreground 212 "Generating facter.json…")
    if $dry_run {
      (gum style --foreground 214 $"[dry-run] would run: nixos-facter -o ($flake)/modules/hosts/($host)/facter.json")
    } else {
      let result = (
        nixos-facter -o $"($flake)/modules/hosts/($host)/facter.json"
        | complete
      )
      if $result.exit_code != 0 {
        (gum style --foreground 214 "Warning: facter generation failed, using committed facter.json")
      }
    }
  }

  # ── Confirm ────────────────────────────────────────────────────────────────
  let confirmed = try { gum confirm $"Install ($host) onto ($disk)? This will ERASE the disk."; true } catch { false }
  if not $confirmed {
    (gum style --foreground 196 "Aborted.")
    exit 1
  }

  # ── Install ────────────────────────────────────────────────────────────────
  (gum style --foreground 212 $"Installing ($host) onto ($disk)…")
  if $dry_run {
    (gum style --foreground 214 $"[dry-run] would run: disko --flake ($flake)#($host)")
    (gum style --foreground 214 $"[dry-run] would run: sbctl create-keys")
    (gum style --foreground 214 $"[dry-run] would run: sbctl enroll-keys --microsoft")
    (gum style --foreground 214 $"[dry-run] would run: SHELL=\"/bin/sh\" nixos-install --flake \"($flake)#($host)\" --no-root-passwd")
    (gum style --foreground 214 $"[dry-run] would run: cp -r ($flake) /mnt/persistent/lepton")
  } else {
#    (gum style --foreground 212 "Running disko…")
#    disko --mode disko --flake $"($flake)#($host)"
#    (gum style --foreground 212 "Generating secure boot keys…")
#
#    sbctl create-keys
#    chattr -i /sys/firmware/efi/efivars/db-* /sys/firmware/efi/efivars/KEK-*
#    try { sbctl enroll-keys --microsoft }
#
#    mkdir /mnt/etc/secureboot/
#    cp -r /var/lib/sbctl/keys /mnt/etc/secureboot/keys
#   mkdir /mnt/persistent/etc/secureboot/
#    cp -r /var/lib/sbctl/keys /mnt/persistent/etc/secureboot/keys
#
#    (gum style --foreground 212 "Running nixos-install…")
#    nixos-install --flake $"($flake)#($host)" --no-root-passwd
#
#    (gum style --foreground 212 "Copying flake to target…")
#    cp -r $flake /mnt/persistent/lepton
#  }

    (gum style --foreground 212 "Generating secure boot keys…")
    sbctl create-keys
    chattr -i /sys/firmware/efi/efivars/db-* /sys/firmware/efi/efivars/KEK-*
    try { sbctl enroll-keys --microsoft }

    (gum style --foreground 212 "Running disko-install…")
    (disko-install
      --mode format
      --flake $"($flake)#($host)"
      --write-efi-boot-entries
      --mount-point "/mnt"
      --disk main $disk
      --extra-files "/var/lib/sbctl/keys" "/etc/secureboot/keys")

    mkdir /mnt/persistent/etc/secureboot
    cp -r /var/lib/sbctl/keys /mnt/persistent/etc/secureboot/keys

    (gum style --foreground 212 "Copying flake to target…")
    cp -r $flake /mnt/persistent/lepton
  }

  (gum style
    --foreground 46 --border-foreground 46 --border rounded
    --align center --width 50 --margin "1 2"
    "Done! Remove the USB and reboot.")
}