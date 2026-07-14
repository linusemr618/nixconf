{
  flake.modules.nixos.minimal = {...}: {
    #documentation.man.cache.enable = false;
  };
  flake.modules.homeManager.minimal = {...}: {
    #programs.man.generateCaches = false;
  };
}
