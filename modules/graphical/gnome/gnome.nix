{
  flake.modules.nixos.graphicalGnome = {pkgs, ...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.sushi.enable = true;
    };
    environment.systemPackages = with pkgs; [nautilus-python];
  };

  flake.modules.homeManager.graphicalGnome = {...}: {programs.gnome-shell.enable = true;};
}
