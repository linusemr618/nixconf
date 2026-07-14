{
  flake.modules.nixos.hostsIso = {
    lib,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")];
    boot.supportedFilesystems.zfs = lib.mkForce false;
    isoImage.squashfsCompression = "zstd -Xcompression-level 3";
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
