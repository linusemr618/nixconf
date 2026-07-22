{...}: {
  flake.modules.nixos.graphical = {config, ...}: {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "${config.var.user.name}";
      };
    };
  };

  flake.modules.homeManager.graphical = {...}: {
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
