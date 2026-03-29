{
  lepton.wayland = {
    nixos =
      { pkgs, lib, ... }:
      {
        programs.dconf.enable = true;
        environment = {
          systemPackages = [ pkgs.wl-clipboard ];
          sessionVariables.NIXOS_OZONE_WL = "1";
        };
      };
    };

    homeManager =
    { user, ... }:
    {
      qt.enable = true;
      gtk = {
        enable = true;
        gtk3.bookmarks = [
          "file:///home/${user.userName}/Downloads Downloads"
          "file:///home/${user.userName}/Documents Documents"
          "file:///home/${user.userName}/Coding Coding"
          "file:///home/${user.userName}/Art Art"
        ];
      };
    };
}