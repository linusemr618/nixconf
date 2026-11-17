{...}: {
  flake.modules.nixos.graphical = {config, ...}: {
    environment.sessionVariables.NIXOS_OZONE_WL = 1;
    security.rtkit.enable = true;
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
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
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
