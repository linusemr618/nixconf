{...}: {
  flake.modules.nixos.graphical = {pkgs, ...}: {
    programs.nix-ld.libraries = with pkgs; [
      libsecret
      glib
    ];
  };

  flake.modules.homeManager.graphical = {...}: {
    programs.zed-editor = {
      enable = true;
      extensions = ["nix"];
      defaultEditor = true;
      #mutableUserSettings = false;
      userSettings = {
        agent.dock = "right";
        agent_servers.claude-acp.type = "registry";
        autosave = "on_focus_change";
        base_keymap = "VSCode";
        collaboration_panel.dock = "left";
        edit_predictions = {
          allow_data_collection = "no";
          provider = "copilot";
        };
        format_on_save = "off";
        git_panel.dock = "left";
        hour_format = "hour24";
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
      };
    };

    #xdg.autostart.entries = ["${pkgs.zed-editor}/share/applications/dev.zed.Zed.desktop"];
  };
}
