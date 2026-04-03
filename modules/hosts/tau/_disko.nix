{
  disko.devices.disk.main = {
    type = "disk";
    device = "";
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
          size = "200G";
          type = "0700";
          content = {
            type = "filesystem";
            format = "ntfs";
          };
        };

        games = {
          size = "800G";
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
            type = "btrfs";
            extraArgs = [ "-f" "-L" "NIXROOT" ];
            subvolumes = {
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
              "/tmp" = {
                mountpoint = "/tmp";
                mountOptions = [ "compress=zstd" "noatime" ];
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

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [ "relatime" "mode=755" "size=2G" ];
  };
}