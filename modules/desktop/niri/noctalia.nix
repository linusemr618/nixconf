{
  flake.nixosModules.desktopNiri = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      noctalia-shell
    ];
  };
}
