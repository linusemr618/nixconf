{...}: {
  flake.modules.nixos.graphical = {config, ...}: {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "${config.var.user.name}";
        };
      };
      printing.enable = true;
    };
  };

  flake.modules.homeManager.graphical = {...}: {
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
