{
  flake.modules.homeManager.minimal = {...}: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
