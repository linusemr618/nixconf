{
  flake.nixosModules.desktop = {config, ...}: {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "${config.user.name}";
      };
    };
  };

  flake.homeModules.desktop = {
    dconf.enable = true;
    xdg = {
      enable = true;
      autostart.enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
      };
    };
  };
}
