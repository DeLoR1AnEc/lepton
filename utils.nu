# ==== NixOS ====

export def nixos-switch [
  name: string
  mode: string
] {
  print $"nixos-switch '($name)' in '($mode)' mode..."
  print (repeat-str "=" 50)
  if $mode == "debug" {
    nixos-rebuild switch --sudo --flake $".#flake.nixosConfigurations.($name)" --show-trace --verbose
  } else {
    nixos-rebuild switch --sudo --flake $".#flake.nixosConfigurations.($name)"
  }
}

export def nixos-install [name: string] {
  print $"Installing '($name)'..."

  print "Running disko..."
  sudo nix run github:nix-community/disko -- --mode disko --flake $".#flake.nixosConfiguration.($name)"

  print "Running nixos-install..."
  sudo nixos-install --flake $".#flake.nixosConfigurations.($name)" --no-root-passwd
}

export def gen-facter [name: string] {
  print $"Generating facter.json for '($name)'..."
  sudo nix run github:nix-community/nixos-facter -- -o $"modules/hosts/($name)/facter.json"
  git add .
}