{
  inputs,
  self,
  ...
}: let
  host = "iso";
  hostModule = "hostsIso";
in {
  flake.nixosConfigurations.${host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({config, ...}: {
        imports = [
          self.modules.nixos.${hostModule}
          self.modules.nixos.minimal
          self.modules.nixos.graphical
          self.modules.nixos.graphicalGnome
        ];
        home-manager.users.${config.var.user.name}.imports = [
          self.modules.homeManager.${hostModule}
          self.modules.homeManager.minimal
          self.modules.homeManager.graphical
          self.modules.homeManager.graphicalGnome
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
    imports = [(modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")];
    boot.supportedFilesystems.zfs = lib.mkForce false;
    isoImage.squashfsCompression = "zstd -Xcompression-level 6";
    nixpkgs.hostPlatform = "x86_64-linux";
  };
  flake.modules.homeManager.${hostModule} = {...}: {
    var.host.name = host;
  };

  perSystem = {...}: {
    packages.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
