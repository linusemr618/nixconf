{...}: {
  flake.modules.nixos.graphicalHyprland = {pkgs, ...}: {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true; # recommended for most users
        xwayland.enable = true; # Xwayland can be disabled.
      };
    };
    services.displayManager.gdm = {
      enable = true;
      #wayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };
  };

  flake.modules.homeManager.graphicalHyprland = {...}: {
    programs.kitty.enable = true;
    wayland.windowManager.hyprland.enable = true;
  };
}
