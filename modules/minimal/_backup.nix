{...}: {
  flake.modules.homeManager.minimal = {pkgs, ...}: {
    home.packages = [pkgs.restic];
  };
}
