{...}: {
  flake.modules.nixos.graphicalGnome = {pkgs, ...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    environment.systemPackages = [pkgs.nautilus-python];
  };

  flake.modules.homeManager.graphicalGnome = {pkgs, ...}: {
    programs.gnome-shell.enable = true;
    home.packages = with pkgs; [
      gnome-firmware
      gnome-network-displays
      gnome-tweaks
    ];
  };
}
