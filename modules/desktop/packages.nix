{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gparted
    ];
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      dconf-editor
      fractal
      gnome-boxes
      gnome-tweaks
      jetbrains.pycharm
      plex-desktop
      proton-pass
      proton-vpn
      spotify
      sqlitebrowser
      vlc
    ];

    #xdg.autostart.entries = ["${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"];
  };
}
