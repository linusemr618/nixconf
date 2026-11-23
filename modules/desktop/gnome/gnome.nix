{...}: {
  flake.modules.nixos.desktopGnome = {pkgs, ...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    environment.systemPackages = [pkgs.nautilus-python];
  };

  flake.modules.homeManager.desktopGnome = {pkgs, ...}: {
    programs.gnome-shell.enable = true;
    home.packages = with pkgs; [
      gnome-firmware
      gnome-network-displays
      gnome-tweaks
    ];
  };
}
