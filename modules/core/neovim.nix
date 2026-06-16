{
  flake.modules.homeManager.core = {pkgs, ...}: {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-colorizer-lua
        nvim-tree-lua
        nvim-treesitter.withAllGrammars
        vim-startify
      ];
      viAlias = true;
      vimAlias = true;
    };
  };
}
