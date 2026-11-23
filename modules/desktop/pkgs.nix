{...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = [pkgs.gparted];
    fonts.packages = [pkgs.corefonts];
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      dconf-editor
      sqlitebrowser
      vlc
    ];

    #xdg.autostart.entries = ["${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"];
  };
}
