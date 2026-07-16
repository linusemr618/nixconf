{
  flake.modules.homeManager.hostsLaptop = {pkgs, ...}: {
    home.packages = with pkgs; [
      jetbrains.pycharm
      libreoffice
    ];
  };
}
