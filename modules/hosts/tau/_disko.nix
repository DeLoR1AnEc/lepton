{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0777" ];
          };
        };

        windows = {
          size = "400G";
          type = "0700";
          content = {
            type = "filesystem";
            format = "ntfs";
          };
        };

        games = {
          size = "600GB";
          content = {
            type = "filesystem";
            format = "btrfs";
            mountpoint = "/games";
            mountOptions = [ "compress=zstd" "noatime" ];
            extraArgs = [ "-f" "-L" "GAMES" ];
          };
        };

        linux = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [ "-f" "-L" "NIXROOT" ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" "subvol=root" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" "subvol=nix" ];
                };
                "/persistent" = {
                  mountpoint = "/persistent";
                  mountOptions = [ "compress=zstd" "noatime" "subvol=persistent" ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" "subvol=home" ];
                };
                "/log" = {
                  mountpoint = "/log";
                  mountOptions = [ "compress=zstd" "noatime" "subvol=log" ];
                };
                "/snapshots" = {
                  mountpoint = "/snapshots";
                  mountOptions = [ "compress=zstd" "noatime" "subvol=snapshots" ];
                };
              };
            };
          };
        };
      };
    };
  };
}