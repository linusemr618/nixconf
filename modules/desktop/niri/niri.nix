{
  flake.nixosModules.desktopNiri = {pkgs, ...}: {
    programs = {
      niri = {
        enable = true;
        useNautilus = true;
      };
    };
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [
        swayidle
        xwayland-satellite
      ];
    };
    hardware.bluetooth.enable = true;
    security = {
      pam.services.greetd.enableGnomeKeyring = true;
      polkit.enable = true;
    };
    services = {
      /*
        greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${config.programs.niri.package}/bin/niri-session";
            user = "${config.user.name}";
          };
        };
      };
      */
      #displayManager.gdm.enable = true;
      gnome.gnome-keyring.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
    systemd.user.services.niri.enableDefaultPath = false;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-gnome];
    };
  };

  flake.homeModules.desktopNiri = {pkgs, ...}: {
    programs = {
      fuzzel.enable = true;
    };
    home.packages = with pkgs; [
      kitty
    ];
  };
}
