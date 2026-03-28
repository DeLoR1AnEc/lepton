{
  description = "Delorianec's NixOS config";

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs;} (inputs.import-tree ./modules);

  inputs = {
    # Dendritic stuff
    den.url = "github:vic/den";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    flake-aspects.url = "github:vic/flake-aspects";

    # Package repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    sysc-greet = {
      url = "github:Nomadcxx/sysc-greet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Misc
    wrapper-manager.url = "github:viperML/wrapper-manager";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Desktop
    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "schemes";
    };
  };
}