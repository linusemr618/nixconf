{
  inputs,
  self,
  ...
}: let
  host = "raspi";
  hostModule = "hostsRaspi";
in {
  flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({config, ...}: {
        imports = [
          self.modules.nixos.${hostModule}
          self.modules.nixos.minimal
          #self.modules.nixos.graphical
          #self.modules.nixos.graphicalGnome
        ];
        home-manager.users.${config.var.user.name}.imports = [
          self.modules.homeManager.${hostModule}
          self.modules.homeManager.minimal
          #self.modules.homeManager.graphical
          #self.modules.homeManager.graphicalGnome
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
      (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
      inputs.nixos-hardware.nixosModules.raspberry-pi-5
    ];
    boot.supportedFilesystems.zfs = lib.mkForce false;
    hardware.raspberry-pi.firmware.uboot.enable = true;
    nixpkgs.hostPlatform = "aarch64-linux";
  };
  flake.modules.homeManager.${hostModule} = {...}: {
    var.host.name = host;
  };

  perSystem = {...}: {
    packages.raspi = self.nixosConfigurations.raspi.config.system.build.sdImage;
  };
}
