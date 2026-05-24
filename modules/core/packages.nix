{
  flake.nixosModules.core = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      aircrack-ng
    ];
  };

  flake.homeModules.core = {pkgs, ...}: {
    home.packages = with pkgs; [
      android-tools
      devenv
      gcc
      gdb
      git
      neovim
      wget

      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
