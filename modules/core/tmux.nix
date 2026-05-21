{
  flake.homeModules.core = {
    programs.tmux = {
      enable = true;
      clock24 = true;
    };
  };
}
