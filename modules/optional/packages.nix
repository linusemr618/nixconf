{...}: {
  flake.modules.homeManager.optional = {pkgs, ...}: {
    home.packages = with pkgs; [
      #deckcraft
      jetbrains.pycharm
      libreoffice
      wineWow64Packages.waylandFull
      winetricks
      wordcraft
    ];
  };
}
