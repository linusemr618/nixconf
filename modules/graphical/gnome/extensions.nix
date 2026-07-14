{
  flake.modules.homeManager.graphicalGnome = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.gnome-shell.extensions = map (i: {package = pkgs.gnomeExtensions.${i};}) [
      "adw-gtk3-colorizer"
      "appindicator"
      #"blur-my-shell"
      "caffeine"
      "clipboard-indicator"
      #"dash-to-dock"
      #"forge"
      "gsconnect"
      #"paperwm"
    ];

    dconf.settings = with lib.hm.gvariant; let
      pixel8ProId = "c57b85519318447aba3aa6407d26329e";
    in {
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
        #enable-mpris = true;
        #nightlight-control = "always";
        show-notifications = false;
        toggle-shortcut = ["<Super>c"];
      };

      "org/gnome/shell/extensions/gsconnect".name = "${config.custom.host.name}";
      "org/gnome/shell/extensions/gsconnect/device/${pixel8ProId}/plugin/battery" = {
        full-battery-notification = true;
        send-statistics = true;
      };
      "org/gnome/shell/extensions/gsconnect/device/${pixel8ProId}/plugin/clipboard" = {
        receive-content = true;
        send-content = true;
      };
      "org/gnome/shell/extensions/gsconnect/device/${pixel8ProId}/plugin/notification".send-notifications = false;
      "org/gnome/shell/extensions/gsconnect/device/${pixel8ProId}/plugin/runcommand".command-list = [
        (mkDictionaryEntry ["lock" (mkVariant [(mkDictionaryEntry ["name" "Lock"]) (mkDictionaryEntry ["command" "xdg-screensaver lock"])])])
        (mkDictionaryEntry ["logout" (mkVariant [(mkDictionaryEntry ["name" "Log Out"]) (mkDictionaryEntry ["command" "gnome-session-quit --logout --no-prompt"])])])
        (mkDictionaryEntry ["poweroff" (mkVariant [(mkDictionaryEntry ["name" "Power Off"]) (mkDictionaryEntry ["command" "systemctl poweroff"])])])
        (mkDictionaryEntry ["suspend" (mkVariant [(mkDictionaryEntry ["name" "Suspend"]) (mkDictionaryEntry ["command" "systemctl suspend"])])])
        (mkDictionaryEntry ["8a4c9cfe-2f53-4b9f-9007-e32e52840529" (mkVariant [(mkDictionaryEntry ["name" "Hibernate"]) (mkDictionaryEntry ["command" "systemctl hibernate"])])])
      ];
      "org/gnome/shell/extensions/gsconnect/device/${pixel8ProId}/plugin/share".launch-urls = true;
    };
  };

  flake.modules.nixos.graphicalGnome = {...}: {
    networking.firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
