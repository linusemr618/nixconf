{self, ...}: {
  hosts.iso = [
    "base"

    "desktop"
    "desktopGnome"
  ];

  flake.modules.nixos.hostsIso = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")];
    boot.supportedFilesystems.zfs = lib.mkForce false;
    isoImage.squashfsCompression = "zstd -Xcompression-level 6";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };

  perSystem = {...}: {
    packages.iso = self.nixosConfigurations.iso.config.system.build.isoImage;
  };
}
