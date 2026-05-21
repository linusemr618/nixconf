{
  flake.homeModules.desktopGnome = {pkgs, ...}: let
    extensions = with pkgs.gnomeExtensions; [
      appindicator
      #blur-my-shell
      caffeine
      clipboard-indicator
      #dash-to-dock
      forge
      gsconnect
      paperwm
    ];
  in {
    programs.gnome-shell.extensions = map (i: {package = i;}) extensions;

    dconf.settings = {
      "org/gnome/shell/extensions/appindicator" = {
        compact-mode-enabled = false;
        icon-saturation = 0.5;
      };
      "org/gnome/shell/extensions/clipboard-indicator" = {
        cache-size = 8;
        clear-history = ["<Control>F9"];
        history-size = 16;
        preview-size = 32;
        toggle-menu = ["<Control>F10"];
      };
      "org/gnome/shell/extensions/caffeine" = {
        enable-mpris = true;
        nightlight-control = "always";
        show-notifications = false;
        toggle-shortcut = ["<Super>c"];
      };
    };
  };
}
