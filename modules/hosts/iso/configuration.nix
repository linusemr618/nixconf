{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.hostsIso
      self.modules.nixos.minimal
      self.modules.nixos.graphical
      self.modules.nixos.graphicalGnome

      ({config, ...}: {
        home-manager.users.${config.user.name}.imports = [
          self.modules.homeManager.hostsIso
          self.modules.homeManager.minimal
          self.modules.homeManager.graphical
          self.modules.homeManager.graphicalGnome
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
