# Dendritic NixOS Flake
![STANDART_MODEL](assets/standart_model.png)

## Installation
Build the installer image
```bash
nix build .#flake.nixosConfigurations.installer.config.system.build.isoImage
```

Flash it
```bash
dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress && sync
```

Run the installer
```bash
lepton-install
```