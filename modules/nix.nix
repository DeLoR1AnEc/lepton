{ inputs, ... }:
{
  den.default.nixos = {
    imports = [ inputs.nix-index-database.nixosModules.nix-index ];
    nixpkgs.config.allowUnfree = true;
    programs.nix-index-database.comma.enable = true;
    programs.nix-ld.enable = true;

    nix = {
      # Optimization
      optimise = {
        automatic = true;
        dates = "weekly";
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 28d";
      };

      settings = {
        keep-outputs = true;
        keep-derivations = true;
        use-xdg-base-directories = true;
        auto-optimise-store = true;
      };

      registry.nixpkgs.flake = inputs.nixpkgs;

      # Misc
      settings = {
        exerimental-features = [
          "nix-command"
          "flakes"
        ];

        extra-substituters = [
          "https://chaotic-nyx.cachix.org/"
          "https://nix-community.cachix.org"
          "https://nix-gaming.cachix.org"
        ];

        extra-trusted-public-keys = [
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];

        builders-use-substitutes = true;
      };
    };

    system.stateVersion = "22.05";
  };
}