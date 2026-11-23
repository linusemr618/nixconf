{...}: {
  flake.modules.homeManager.base = {...}: {
    programs.neovim = {
      enable = true;
      # plugins = with pkgs.vimPlugins; [
      #   nvim-colorizer-lua
      #   nvim-tree-lua
      #   nvim-treesitter.withAllGrammars
      #   vim-startify
      # ];
      viAlias = true;
      vimAlias = true;
    };
  };
}
