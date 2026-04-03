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
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        builders-use-substitutes = true;
      };
    };

    system.stateVersion = "25.11";
  };
}