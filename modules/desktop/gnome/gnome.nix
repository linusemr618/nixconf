{
  flake.modules.nixos.desktopGnome = {...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.sushi.enable = true;
    };
  };

  flake.modules.homeManager.desktopGnome = {...}: {
    programs.gnome-shell.enable = true;
  };
}
