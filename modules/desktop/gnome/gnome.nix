{
  flake.nixosModules.desktopGnome = {config, ...}: {
    services.displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "${config.user.name}";
      };
    };
    services.desktopManager.gnome.enable = true;
  };

  flake.homeModules.desktopGnome = {
    programs.gnome-shell.enable = true;
  };
}
