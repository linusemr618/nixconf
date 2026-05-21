{
  flake.nixosModules.hostsLaptop = {
    config,
    lib,
    #pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
      ];
      initrd.kernelModules = [];
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
      zswap.enable = true;
    };

    fileSystems."/" = {
      device = "/dev/mapper/luks-790845fb-5510-436c-9e2b-3abff24f506a";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
    };

    boot.initrd.luks.devices."luks-790845fb-5510-436c-9e2b-3abff24f506a".device = "/dev/disk/by-uuid/790845fb-5510-436c-9e2b-3abff24f506a";

    fileSystems."/home" = {
      device = "/dev/mapper/luks-790845fb-5510-436c-9e2b-3abff24f506a";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/F65C-E1F7";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    fileSystems."/swap" = {
      device = "/dev/mapper/luks-790845fb-5510-436c-9e2b-3abff24f506a";
      fsType = "btrfs";
      options = [
        "subvol=@swap"
        "compress=zstd"
        "noatime"
      ];
    };

    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 24 * 1024;
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.resumeDevice = "/dev/mapper/luks-790845fb-5510-436c-9e2b-3abff24f506a";
    boot.kernelParams = [
      "resume_offset=11168313"
    ];
  };
}
