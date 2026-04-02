set shell := ["nu", "-c"]

utils_nu := absolute_path("utils.nu")

default:
    @just --list

# Switch current host
[group('nix')]
[linux]
switch mode="default":
    #!/usr/bin/env nu
    use {{ utils_nu }} *;
    nixos-switch (hostname) {{ mode }}

# Switch specific host
[group('nix')]
[linux]
switch-host name mode="default":
    #!/usr/bin/env nu
    use {{ utils_nu }} *;
    nixos-switch {{ name }} {{ mode }}

# Install a host (run from installer)
[group('nix')]
[linux]
install-lepton:
    #!/usr/bin/env nu
    nu modules/hosts/lepton-installer/installer.nu

# Test installer locally without flashing ISO
[group('nix')]
[linux]
test-installer:
    #!/usr/bin/env nu
    nu modules/hosts/lepton-installer/installer.nu --dry-run

# Generate facter.json for a host (run from installer)
[group('nix')]
[linux]
facter name:
    #!/usr/bin/env nu
    use {{ utils_nu }} *;
    gen-facter {{ name }}

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

# Enroll secure boot keys
[group('nix')]
[linux]
secureboot:
    sudo sbctl enroll-keys --microsoft
