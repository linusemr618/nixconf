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
      extraPackages = with pkgs; [
        alejandra
        nil
        nixd
      ];
      defaultEditor = true;
      #mutableUserSettings = false;
      userSettings = {
        auto_install_extensions.nix = true;
        autosave = "on_focus_change";
        base_keymap = "VSCode";
        buffer_font_size = 15;
        edit_predictions.provider = "copilot";
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
        load_direnv = "shell_hook";
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
