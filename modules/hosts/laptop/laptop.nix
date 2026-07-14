{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({config, ...}: {
        imports = [
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-cpu-intel

          self.modules.nixos.hostsLaptop
          self.modules.nixos.minimal
          self.modules.nixos.graphical
          self.modules.nixos.graphicalGnome
        ];
        home-manager.users.${config.user.name}.imports = [
          self.modules.homeManager.hostsLaptop
          self.modules.homeManager.minimal
          self.modules.homeManager.graphical
          self.modules.homeManager.graphicalGnome
        ];
      })
    ];
  };
  flake.modules.nixos.hostsLaptop = {
    lib,
    pkgs,
    ...
  }: {
    options.host.name = lib.mkOption {
      type = lib.types.str;
      default = "laptop";
    };
    config = {
      boot = {
        resumeDevice = "/dev/mapper/luks-790845fb-5510-436c-9e2b-3abff24f506a";
        kernelParams = ["resume_offset=11168313"];
        zswap.enable = true;

        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        kernelPackages = pkgs.linuxPackages_latest;
      };
      swapDevices = [
        {
          device = "/swap/swapfile";
          size = 24 * 1024;
        }
      ];
    };
  };
  flake.modules.homeManager.hostsLaptop = {lib, ...}: {
    options.host.name = lib.mkOption {
      type = lib.types.str;
      default = "laptop";
    };
  };
}
