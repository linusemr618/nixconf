{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostsLaptop
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel

      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.desktopGnome

      ({config, ...}: {
        home-manager.users.${config.user.name}.imports = [
          self.homeModules.core
          self.homeModules.desktop
          self.homeModules.desktopGnome
        ];
      })
    ];
  };
  flake.nixosModules.hostsLaptop = {
    networking.hostName = "laptop";
    boot = {
      resumeDevice = "/dev/mapper/luks-790845fb-5510-436c-9e2b-3abff24f506a";
      kernelParams = ["resume_offset=11168313"];
      zswap.enable = true;
    };
    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 24 * 1024;
      }
    ];
  };
}
