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

        linux = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" "-L" "NIXROOT" ];
            subvolumes = {
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "/persistent" = {
                mountpoint = "/persistent";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "/log" = {
                mountpoint = "/log";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "/tmp" = {
                mountpoint = "/tmp";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "/snapshots" = {
                mountpoint = "/snapshots";
                mountOptions = [ "compress=zstd" "noatime" ];
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