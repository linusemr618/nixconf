{
  inputs,
  self,
  ...
}: {
  hosts.raspi = [
    "base"

    "server"
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
    system.stateVersion = "26.05";
  };

  perSystem = {...}: {
    packages.raspi = self.nixosConfigurations.raspi.config.system.build.sdImage;
  };
}
