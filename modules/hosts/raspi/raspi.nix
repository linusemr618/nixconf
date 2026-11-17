{
  inputs,
  self,
  ...
}: {
  hosts.raspi = [
    "minimal"
  ];
  flake.modules.nixos.hostsRaspi = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
      inputs.nixos-hardware.nixosModules.raspberry-pi-5
    ];
    boot.supportedFilesystems.zfs = lib.mkForce false;
    hardware.raspberry-pi.firmware.uboot.enable = true;
    nixpkgs.hostPlatform = "aarch64-linux";
  };

  perSystem = {...}: {
    packages.raspi = self.nixosConfigurations.raspi.config.system.build.sdImage;
  };
}
