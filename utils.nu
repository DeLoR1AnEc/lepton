# ==== NixOS ====

export def nixos-switch [
  name: string
  mode: string
] {
  print $"nixos-switch '($name)' in '($mode)' mode..."
  print (repeat-str "=" 50)
  if $mode == "debug" {
    nixos-rebuild switch --sudo --flake $".#($name)" --show-trace --verbose
  } else {
    nixos-rebuild switch --sudo --flake $".#($name)"
  }
}

export def nixos-install [
  name: string
  disk: string
] {
  print $"Installing '($name)'..."

  print "Running disko..."
  sudo nix run github:nix-community/disko -- --mode disko --flake $".#($name)" --disk main $disk

  print "Running nixos-install..."
  sudo nixos-install --flake $".#($name)" --no-root-passwd

  print "Copying flake to target..."
  sudo cp -r $env.PWD /mnt/persistent/lepton
}

export def gen-facter [name: string] {
  print $"Generating facter.json for '($name)'..."
  sudo nix run github:nix-community/nixos-facter -- -o $"modules/hosts/($name)/facter.json"
  git add .
}