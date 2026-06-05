{
  flake.modules.nixos.desktopNiri = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      noctalia-shell
    ];
  };
}
