{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ({
        config,
        modulesPath,
        ...
      }: {
        imports = [
          (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")

          self.modules.nixos.hostsIso
          self.modules.nixos.minimal
          self.modules.nixos.graphical
          self.modules.nixos.graphicalGnome
        ];
        home-manager.users.${config.custom.user.name}.imports = [
          self.modules.homeManager.hostsIso
          self.modules.homeManager.minimal
          self.modules.homeManager.graphical
          self.modules.homeManager.graphicalGnome
        ];
      })
    ];
  };
  flake.modules.nixos.hostsIso = {lib, ...}: {
    custom.host.name = "iso";
    boot.supportedFilesystems.zfs = lib.mkForce false;
    isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    nixpkgs.hostPlatform = "x86_64-linux";
  };
  flake.modules.homeManager.hostsIso = {...}: {
    custom.host.name = "iso";
  };
  perSystem = {
    packages.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
