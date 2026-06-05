{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = [pkgs.geary];
    services.protonmail-bridge.enable = true;

    dconf.settings."org/gnome/Geary".run-in-background = true;
  };
}
