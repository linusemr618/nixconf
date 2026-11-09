{
  inputs,
  self,
  ...
}: let
  host = "laptop";
  hostModule = "hostsLaptop";
in {
  flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({config, ...}: {
        imports = [
          self.modules.nixos.${hostModule}
          self.modules.nixos.minimal
          self.modules.nixos.graphical
          self.modules.nixos.graphicalGnome
          self.modules.nixos.optional
        ];
        home-manager.users.${config.var.user.name}.imports = [
          self.modules.homeManager.${hostModule}
          self.modules.homeManager.minimal
          self.modules.homeManager.graphical
          self.modules.homeManager.graphicalGnome
          self.modules.homeManager.optional
        ];
      })
    ];
  };
  flake.modules.nixos.${hostModule} = {
    lib,
    modulesPath,
    ...
  }: {
    var.host.name = host;
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
      kernelParams = ["resume_offset=11168313"];
      resumeDevice = "/dev/mapper/crypted";
      zswap.enable = true;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
  flake.modules.homeManager.${hostModule} = {...}: {
    var.host.name = host;
  };
}
