{
  den.schema.user.classes = [ "homeManager" ];

  den.default = {
    nixos =
      { pkgs, ... }:
      {
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
        stateVersion = "22.05";
      };
    };
  };
}