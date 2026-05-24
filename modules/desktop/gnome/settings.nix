{
  flake.homeModules.desktopGnome = {lib, ...}:
    with lib.hm.gvariant; {
      dconf.settings = {
        "org/gnome/desktop/calendar".show-weekdate = true;
        "org/gnome/desktop/date-time".automatic-timezone = true;
        "org/gnome/desktop/interface".gtk-enable-primary-paste = true;
        "org/gnome/desktop/notifications".show-in-lock-screen = false;
        "org/gnome/desktop/peripherals/mouse".speed = -0.75;
        "org/gnome/desktop/privacy" = {
          recent-files-max-age = 30;
          remove-old-temp-files = true;
          remove-old-trash-files = true;
        };
        "org/gnome/desktop/screensaver".lock-delay = mkUint32 60;
        "org/gnome/mutter".experimental-features = ["kms-modifiers" "autoclose-xwayland"];
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = true;
          night-light-temperature = mkUint32 3700;
        };
        "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>Return";
          command = "kgx";
          name = "Launch Console";
        };
        "org/gnome/settings-daemon/plugins/power".power-button-action = "hibernate";
        "org/gnome/shell".favorite-apps = ["brave-browser.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Console.desktop" "org.gnome.TextEditor.desktop" "dev.zed.Zed.desktop" "pycharm.desktop"];
        "org/gnome/system/location".enabled = true;

        "org/gnome/nautilus/list-view" = {
          default-zoom-level = "small";
          use-tree-view = true;
        };
        "org/gnome/nautilus/preferences" = {
          recursive-search = "always";
          default-folder-viewer = "list-view";
          show-create-link = true;
        };

        "org/gnome/gnome-system-monitor" = {
          show-whose-processes = "all";
          cpu-stacked-area-chart = true;
          resources-memory-in-iec = true;
        };
      };
      xdg.configFile."goa-1.0/accounts.conf".text = ''
        [Account account_1779291630_0]
        Provider=owncloud
        Identity=linusemmerich
        PresentationIdentity=linusemmerich@nextcloud.kaffeekanne.xyz
        Uri=https://nextcloud.kaffeekanne.xyz:443/remote.php/webdav/
        FilesEnabled=true
        CalendarEnabled=true
        CalDavUri=https://nextcloud.kaffeekanne.xyz:443/remote.php/dav/
        ContactsEnabled=true
        CardDavUri=https://nextcloud.kaffeekanne.xyz:443/remote.php/dav/
        AcceptSslErrors=false

        [Account account_1779555501_0]
        Provider=google
        Identity=REDACTED_GMAIL
        PresentationIdentity=REDACTED_GMAIL
        MailEnabled=true
        CalendarEnabled=true
        ContactsEnabled=true
      '';
    };
}
