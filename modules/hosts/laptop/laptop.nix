{inputs, ...}: {
  hosts.laptop = [
    "base"
    "baseSecrets"

    "desktop"
    "desktopGnome"
    "desktopGnomeSecrets"

    "element"
    "extrapkgs"
    "dev"
    "networks"
    #"ollama"
    "proton-vpn"
    "tailscale"
    "virtualisation"
  ];

  flake.modules.nixos.hostsLaptop = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel
    ];
    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      initrd.availableKernelModules = ["xhci_pci" "nvme"];
      kernelModules = ["kvm-intel"];
      kernelParams = ["resume_offset=11168313"]; # btrfs inspect-internal map-swapfile -r /.swap/swapfile
      resumeDevice = "/dev/mapper/crypted";
      zswap.enable = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
