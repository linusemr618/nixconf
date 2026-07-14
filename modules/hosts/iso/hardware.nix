{
  flake.modules.nixos.hostsIso = {modulesPath, ...}: {
    imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
  };
}
