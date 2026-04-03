{ inputs, ... }:
{
  lepton.preservation._ = {
    system.nixos = {
      imports = [ inputs.preservation.nixosModules.default ];

      preservation.enable = true;
      boot.initrd.systemd.enable = true;

      systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

      fileSystems."/persistent".neededForBoot = true;

      preservation.preserveAt."/persistent" = {
        directories = [
          "/lepton"

          "/etc/ssh"
          "/etc/secureboot"
          "/etc/NetworkManager/system-connections"
          "/etc/nix/inputs"

          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd"
          { directory = "/var/lib/private"; mode = "0700"; }
          "/var/lib/bluetooth"
          "/var/NetworkManager"
          "/var/tailscale"
        ];
        files = [
          { file = "/etc/machine-id"; inInitrd = true; }
          "/var/lib/sops-age-key"
        ];
      };
    };

    user =
      { host, user, ... }:
      {
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

          preservation.preserveAt."/persistent".users.${user.userName} = {
            commonMountOptions = [ "x-gvfs-hide" ];
            directories = [
              # XDG
              "Downloads"
              "Music"
              "Pictures"
              "Documents"
              "Videos"

              # Nix / Home manager
              ".local/state/home-manager"
              ".local/state/nix/"
              ".local/share/nix"
              ".cache/nix"
              ".cache/nixpkgs-review"

              # Shell
              ".local/share/nushell"

              # Security
              { directory = ".ssh";   mode = "0700"; }
              { directory = ".gnupg"; mode = "0700"; }
              { directory = ".pki";   mode = "0700"; }
              ".local/share/password-store"

              # Gaming / Media
              ".local/share/PrismLauncher"
              ".steam"
              ".local/share/Steam"
              ".config/lutris"
              ".local/share/lutris"

              ".config/obs-studio"

              ".local/share/krita"

              # Browsers
              ".mozilla"

              # Editors
              ".local/share/nvim"
              ".local/state/nvim"
              ".config/zed"
              ".local/share/zed"

              # Cli
              ".local/share/atuin"
              ".local/share/zoxide"
              ".cache/tealdeer"

              # Misc
              ".local/share/keyrings"
              ".config/pulse"
              ".local/state/wireplumber"

              # Language Package Managers
              ".npm"
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