{ inputs, lib, ... }:
{
  lepton.boot.nixos = {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "max";
    };

    boot.loader.timeout = 8;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];
  };

  lepton.boot._ = {
    secure.nixos = {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      boot = {
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };
      };
    };

    greeter =
      { host, user, ...}:
      {
        nixos = {
          imports = [ inputs.sysc-greet.nixosModules.default ];
          services.sysc-greet = {
            enable = true;
            compositor = host.compositor;
            settings.initial_session = {
              command = host.compositor;
              user = user.userName;
            };
          };
        };
      };
  };
}