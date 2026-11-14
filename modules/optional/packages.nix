{inputs, ...}: {
  flake.modules.nixos.optional = {...}: {
    # programs.appimage = {
    #   enable = true;
    #   binfmt = true;
    #   package = pkgs.appimage-run.override {
    #     extraPkgs = pkgs: [
    #         pkgs.libxshmfence
    #       ];
    #   };
    # };
    services.flatpak.enable = true;
  };
  flake.modules.homeManager.optional = {pkgs, ...}: {
    home.packages = with pkgs; [
      (pkgs.callPackage "${inputs.nixpkgs-pr-claude-desktop}/pkgs/by-name/cl/claude-desktop/package.nix" {})
      deckcraft
      ffmpeg-full
      #fractal
      gnome-boxes
      jetbrains.pycharm
      #libreoffice
      plex-desktop
      proton-drive-cli #(pkgs.callPackage "${inputs.nixpkgs-pr-proton-drive-cli}/pkgs/by-name/pr/proton-drive-cli/package.nix" {})
      spotify
      wineWow64Packages.waylandFull
      winetricks
      wordcraft
    ];
  };
}
