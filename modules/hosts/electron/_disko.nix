{
 disko.devices.disk.main = {
    type = "disk";
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