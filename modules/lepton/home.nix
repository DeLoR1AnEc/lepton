{ inputs, ... }:
{
  lepton.home = {
    nixos =
      { pkgs, ... }:
      {
        imports = [ inputs.home-manager.nixosModules.default ];

        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
        };

        environment.shells = with pkgs; [
          bashInteractive
          nushell
        ];

        users.defaultUserShell = pkgs.bashInteractive;
      };

    homeManager = {
      programs.home-manager.enable = true;
      home = {
        sessionPath = [ "$HOME/.local/bin" ];
        sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
        stateVersion = "25.11";
      };
    };
  };
}