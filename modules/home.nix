{
  den.schema.user =
    { user, lib, ... }: {
      config.classes = lib.mkDefault [ "homeManager" ];
    };

  den.default = {
    nixos.home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
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