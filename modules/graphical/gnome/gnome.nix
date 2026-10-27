{...}: {
  flake.modules.nixos.graphicalGnome = {
    config,
    lib,
    pkgs,
    ...
  }: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.sushi.enable = true;
    };
    environment.systemPackages = [pkgs.nautilus-python];

    # temp fix for a bug in gdm 50.2; TODO remove in the future
    security.pam.services.gdm-autologin.rules.auth.gdm.modulePath = lib.mkForce "${config.systemd.package}/lib/security/pam_systemd_loadkey.so";
  };

  flake.modules.homeManager.graphicalGnome = {...}: {programs.gnome-shell.enable = true;};
}
