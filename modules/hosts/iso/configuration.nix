{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.hostsIso
      self.modules.nixos.core
      self.modules.nixos.desktop
      self.modules.nixos.desktopGnome

      ({config, ...}: {
        home-manager.users.${config.user.name}.imports = [
          self.modules.homeManager.hostsIso
          self.modules.homeManager.core
          self.modules.homeManager.desktop
          self.modules.homeManager.desktopGnome
        ];
      })
    ];
  };
  flake.modules.nixos.hostsIso = {lib, ...}: {
    options.host.name = lib.mkOption {
      type = lib.types.str;
      default = "iso";
    };
  };
  flake.modules.homeManager.hostsIso = {lib, ...}: {
    options.host.name = lib.mkOption {
      type = lib.types.str;
      default = "iso";
    };
  };
}
