{...}: {
  flake.modules.nixos.desktopNiri = {pkgs, ...}: {
    environment.systemPackages = [pkgs.noctalia-shell];
  };
}
