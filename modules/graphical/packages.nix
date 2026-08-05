{self, ...}: {
  flake.modules.nixos.graphical = {pkgs, ...}: {
    environment.systemPackages = [pkgs.gparted];
  };

  flake.modules.homeManager.graphical = {pkgs, ...}: {
    home.packages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.claude
      dconf-editor
      #fractal
      gnome-boxes
      gnome-network-displays
      gnome-tweaks
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
