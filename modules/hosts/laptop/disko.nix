{inputs, ...}: {
  flake.modules.nixos.hostsLaptop = {...}: {
    imports = [inputs.disko.nixosModules.disko];
  };
}
