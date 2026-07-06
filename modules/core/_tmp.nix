{
  flake.modules.nixos.core = {...}: {
    #documentation.man.cache.enable = false;
  };
  flake.modules.homeManager.core = {...}: {
    #programs.man.generateCaches = false;
  };
}
