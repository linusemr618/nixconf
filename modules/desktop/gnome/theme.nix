{
  flake.homeModules.desktopGnome = {pkgs, ...}: {
    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    gtk = {
      enable = true;

      gtk2.theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
      gtk3.theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        name = "kora";
        package = pkgs.kora-icon-theme;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}
