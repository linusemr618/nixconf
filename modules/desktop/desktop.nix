{
  flake.nixosModules.desktop = {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
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
