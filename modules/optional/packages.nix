{...}: {
  flake.modules.homeManager.optional = {pkgs, ...}: {
    home.packages = with pkgs; [
      jetbrains.pycharm
      libreoffice
    ];
  };
}
