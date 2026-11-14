{...}: {
  flake.modules.nixos.graphical = {pkgs, ...}: {
    environment.systemPackages = [pkgs.gparted];
  };

  flake.modules.homeManager.graphical = {pkgs, ...}: {
    home.packages = with pkgs; [
      dconf-editor
      proton-vpn #(pkgs.callPackage "${inputs.nixpkgs-pr-proton-vpn}/pkgs/by-name/pr/proton-vpn/package.nix" {})
      sqlitebrowser
      vlc
    ];

    #xdg.autostart.entries = ["${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"];
  };
}
