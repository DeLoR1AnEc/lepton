set shell := ["nu", "-c"]

utils_nu := absolute_path("utils.nu")

default:
    @just --list

# Switch current host
[group('nix')]
[linux]
switch mode="default":
    use {{ utils_nu }} *;
    nixos-switch (hostname) {{ mode }}

# Switch specific host
[group('nix')]
[linux]
switch-host name mode="default":
    use {{ utils_nu }} *;
    nixos-switch {{ name }} {{ mode }}

# ==== Installing ====

# Build the installer image
[group('nix')]
[linux]
build-image:
    nix build .#nixosConfigurations.lepton-installer.config.system.build.image

# Flash the installer image to drive
[group('nix')]
[linux]
flash-image drive:
    try { umount /dev/{{ drive }}* }
    dd if=result/iso/lepton-installer.iso of=/dev/{{ drive }} bs=4M status=progress
    sync

# Install a host (run from installer)
[group('nix')]
[linux]
[no-cd]
install-lepton:
    nu /etc/lepton/modules/hosts/lepton-installer/installer.nu

# Generate facter.json for a host (run from installer)
[group('nix')]
[linux]
facter name:
    use {{ utils_nu }} *;
    gen-facter {{ name }}

# ==== Misc ====

# Update flake inputs
[group('nix')]
up:
    nix flake update --commit-lock-file

# Update specific input
[group('nix')]
upp input:
    nix flake update {{ input }} --commit-lock-file

# Garbage collect older than 7 days
[group('nix')]
gc:
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d
