{ inputs, ... }:
{
  lepton.preservation.provides = {
    system.nixos = {
      imports = [ inputs.preservation.nixosModules.default ];

      preservation.enable = true;
      boot.initrd.systemd.enable = true;

      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

      preservation.preserveAt."/persistent" = {
        directories = [
          "/etc/ssh"
          "/etc/NetworkManager/system-connections"
          "/etc/secureboot"
          "/etc/nix/inputs"

          "/var/lib/nixos"
          "/var/lib/systemd"
          { directory = "/var/lib/private"; mode = "0700"; }
          "/var/lib/bluetooth"
          "/var/NetworkManager"
          "/var/tailscale"
        ];
        files = [
          { file = "/etc/machine-id"; inInitrd = true; }
        ];
      };
    };

    user = { host, user, ... }: {
      nixos = {
        systemd.tmpfiles.settings.preservation =
        let
          permission = {
              user = user.userName;
              group = "users";
              mode = "0755";
            };
          in
          {
            "/home/${user.userName}/.config".d = permission;
            "/home/${user.userName}/.cache".d = permission;
            "/home/${user.userName}/.local".d = permission;
            "/home/${user.userName}/.local/share".d = permission;
            "/home/${user.userName}/.local/state".d = permission;
            "/home/${user.userName}/.local/state/nix".d = permission;
          };

        nixos.preservation.preserveAt."/persistent".users.${user.userName} = {
          commonMountOptions = [ "x-gvfs-hide" ];
          directories = [
            # XDG
            "Downloads"
            "Music"
            "Pictures"
            "Documents"
            "Videos"

            # nix / home-manager
            ".local/state/home-manager"
            ".local/state/nix/profiles"
            ".local/share/nix"
            ".cache/nix"
            ".cache.nixpkgs-review"

            # shell
            ".local/share/nushell"

            # security
            { directory = ".shh";   mode = "0700"; }
            { directory = ".gnupg"; mode = "0700"; }
            { directory = ".pki";   mode = "0700"; }
            ".local/share/password-store"

            # gaming / media
            ".local/share/PrismLauncher"
            ".steam"
            ".local/share/Steam"
            ".config/lutris"
            ".local/share/lutris"

            ".config/obs-studio"

            ".local/share/krita"

            # browsers
            ".mozilla"

            # editors
            ".local/share/nvim"
            ".local/state/nvim"
            ".config/zed"
            ".local/share/zed"

            # cli
            ".local/share/atuin"
            ".local/share/zoxide"
            ".cache/tealdeer"

            # misc
            ".local/share/keyrings"
            ".config/pulse"
            ".local/state/wireplumber"

            # language package managers
            ".npn"
            "go"
            ".cargo"
            ".gradle"
            ".local/pipx"
            ".local/bin"
          ];
        };
      };
    };
  };
}