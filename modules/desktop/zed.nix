{
  flake.nixosModules.desktop = {pkgs, ...}: {
    programs.nix-ld.libraries = with pkgs; [
      libsecret
      glib
    ];
  };

  flake.homeModules.desktop = {pkgs, ...}: {
    programs.zed-editor = {
      enable = true;
      extensions = ["nix"];
      defaultEditor = true;
      #mutableUserSettings = false;
      userSettings = {
        agent_panel.dock = "right";
        auto_install_extensions.nix = true;
        autosave = "on_focus_change";
        base_keymap = "VSCode";
        buffer_font_size = 15;
        collaboration_panel.dock = "left";
        edit_predictions.provider = "copilot";
        git_panel.dock = "left";
        hour_format = "hour24";
        icon_theme = {
          mode = "system";
          light = "Zed (Default)";
          dark = "Zed (Default)";
        };
        languages.Nix.formatter.external = {
          command = "alejandra";
          arguments = ["--quiet" "--"];
        };
        outline_panel.dock = "left";
        project_panel.dock = "left";
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
        ui_font_size = 16;
        vim_mode = false;
      };
    };

    xdg.autostart.entries = ["${pkgs.zed-editor}/share/applications/dev.zed.Zed.desktop"];
  };
}
