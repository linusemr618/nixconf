{...}: {
  flake.modules.nixos.graphical = {pkgs, ...}: {
    environment.systemPackages = [pkgs.gparted];
  };

  flake.modules.homeManager.graphical = {pkgs, ...}: {
    home.packages = with pkgs; [
      dconf-editor
      #fractal
      gnome-boxes
      gnome-firmware
      gnome-network-displays
      gnome-tweaks
      plex-desktop
      proton-pass
      proton-vpn
      spotify
      sqlitebrowser
      vlc
      #self.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    ];

    #xdg.autostart.entries = ["${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"];
  };
}
