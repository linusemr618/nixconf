{inputs, ...}: {
  flake.modules.nixos.hostsLaptop = {...}: {
    imports = [inputs.disko.nixosModules.disko];
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "4G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypted";
                  settings.allowDiscards = true;
                  content = {
                    type = "btrfs";
                    extraArgs = ["-f"];
                    subvolumes = {
                      "@" = {
                        mountpoint = "/";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "@home" = {
                        mountpoint = "/home";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "@home_snapshots" = {
                        mountpoint = "/home/.snapshots";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = ["compress=zstd" "noatime"];
                      };
                      "@swap" = {
                        mountpoint = "/.swap";
                        mountOptions = ["noatime"];
                        swap.swapfile.size = "24G";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
