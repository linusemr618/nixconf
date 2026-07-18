{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({config, ...}: {
        imports = [
          self.modules.nixos.hostsLaptop
          self.modules.nixos.minimal
          self.modules.nixos.graphical
          self.modules.nixos.graphicalGnome
        ];
        home-manager.users.${config.custom.user.name}.imports = [
          self.modules.homeManager.hostsLaptop
          self.modules.homeManager.minimal
          self.modules.homeManager.graphical
          self.modules.homeManager.graphicalGnome
          self.modules.homeManager.optional
        ];
      })
    ];
  };
  flake.modules.nixos.hostsLaptop = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    custom.host.name = "laptop";
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel
    ];
    boot = {
      initrd.availableKernelModules = ["xhci_pci" "nvme"];
      kernelModules = ["kvm-intel"];
      resumeDevice = "/dev/mapper/crypted";
      kernelParams = ["resume_offset=11168313"];
      zswap.enable = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
  flake.modules.homeManager.hostsLaptop = {...}: {
    custom.host.name = "laptop";
  };
}
