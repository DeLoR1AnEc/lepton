# Dendritic NixOS Flake
![STANDART_MODEL](assets/standart_model.png)

## Installation
1. Build the installer image
```bash
just build-image
```

2. Flash it to an USB-Drive
```bash
just flash-image
```

3. Run the installer on the end machine
```bash
just install-lepton
```