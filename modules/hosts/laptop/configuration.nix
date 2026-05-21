{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostsLaptop

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
  flake.nixosModules.hostsLaptop = {pkgs, ...}: {
    networking.hostName = "laptop";

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
    boot.kernelParams = ["i915.enable_guc=3"];
  };
}
