{ lib, ... }:
{
  lepton.networking = {
    nixos = {
      networking = {
        networkmanager.enable = true;
        nftables.enable = true;
        wireguard.enable = true;
        firewall.enable = lib.mkDefault false;
      };
    };

    _.ssh = {
      nixos = {
        services.openssh = {
          enable = true;
          settings = {
            X11Forwarding = true;
            PermitRootLogin = "prohibit-password";
            PasswordAuthentication = false;
          };
          openFirewall = true;
        };

        environment.enableAllTerminfo = true;
      };

      homeManager.services.ssh-agent.enable = true;
    };
  };
}