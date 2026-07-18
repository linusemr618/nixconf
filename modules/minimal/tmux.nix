{...}: {
  flake.modules.homeManager.minimal = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
        #set -g status-right "#[fg=black,bg=color15] #{cpu_percentage}  %H:%M "
        #run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      '';
      mouse = true;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.nord
        # {
        #   plugin = tmuxPlugins.resurrect;
        #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        # }
        # {
        #   plugin = tmuxPlugins.continuum;
        #   extraConfig = ''
        #     set -g @continuum-restore 'on'
        #     # set -g @continuum-save-interval '15' # minutes
        #   '';
        # }
      ];
    };
  };
}
