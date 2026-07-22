{...}: {
  flake.modules.homeManager.minimal = {pkgs, ...}: {
    home.packages = with pkgs; [restic];
  };
}
