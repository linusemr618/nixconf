{...}: {
  flake.modules.nixos.graphicalNiri = {pkgs, ...}: {
    environment.systemPackages = [pkgs.noctalia-shell];
  };
}
