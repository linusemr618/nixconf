{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.graphical = {pkgs, ...}: {
    environment.systemPackages = [pkgs.gparted];
  };

  flake.modules.homeManager.graphical = {pkgs, ...}: {
    home.packages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
      dconf-editor
      #fractal
      gnome-boxes
      gnome-firmware
      gnome-network-displays
      gnome-tweaks
      plex-desktop
      proton-pass
      proton-vpn #self.packages.${pkgs.stdenv.hostPlatform.system}.proton-vpn
      spotify
      sqlitebrowser
      vlc
    ];

    #xdg.autostart.entries = ["${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"];
  };

  perSystem = {pkgs, ...}: {
    packages = {
      claude-desktop = pkgs.callPackage "${inputs.nixpkgs-pr-claude-desktop}/pkgs/by-name/cl/claude-desktop/package.nix" {};
      proton-vpn = pkgs.callPackage "${inputs.nixpkgs-pr-proton-vpn}/pkgs/by-name/pr/proton-vpn/package.nix" {};
    };
  };
}
