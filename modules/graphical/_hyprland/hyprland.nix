{...}: {
  flake.modules.nixos.graphicalHyprland = {pkgs, ...}: {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true; # recommended for most users
        xwayland.enable = true; # Xwayland can be disabled.
      };
      kitty.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    };
  };
}
