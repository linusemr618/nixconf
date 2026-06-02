{
  flake.nixosModules.desktopGnome = {...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.sushi.enable = true;
    };
  };

  flake.homeModules.desktopGnome = {...}: {
    programs.gnome-shell.enable = true;
  };
}
