{...}: {
  flake.modules.homeManager.graphicalGnome = {
    config,
    lib,
    ...
  }: {
    dconf.settings = with lib.hm.gvariant; {
      "org/gnome/desktop/calendar".show-weekdate = true;
      #"org/gnome/desktop/datetime".automatic-timezone = true;
      "org/gnome/desktop/input-sources".sources = [(mkTuple ["xkb" "de"])]; #(mkTuple ["xkb" "gb"])];
      "org/gnome/desktop/interface".gtk-enable-primary-paste = true;
      "org/gnome/desktop/notifications".show-in-lock-screen = false;
      "org/gnome/desktop/peripherals/mouse".speed = 0; # -0.75;
      "org/gnome/desktop/privacy" = {
        recent-files-max-age = 30;
        remove-old-temp-files = true;
        remove-old-trash-files = true;
      };
      "org/gnome/desktop/screensaver".lock-delay = mkUint32 60;
      "org/gnome/desktop/wm/keybindings".toggle-fullscreen = ["<Super>F11"];
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
      "org/gnome/shell".favorite-apps = ["zen-beta.desktop" "org.gnome.Nautilus.desktop" "org.gnome.Console.desktop" "org.gnome.TextEditor.desktop" "dev.zed.Zed.desktop" "pycharm.desktop"];
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
      "org/gtk/gtk4/settings/file-chooser".show-hidden = true;

      "org/gnome/gnome-system-monitor" = {
        show-whose-processes = "all";
        cpu-stacked-area-chart = true;
        process-memory-in-iec = true;
        resources-memory-in-iec = true;
      };
    };

    gtk.gtk3.bookmarks = [
      "file://${config.xdg.userDirs.documents} Documents"
      "file://${config.xdg.userDirs.music} Music"
      "file://${config.xdg.userDirs.pictures} Pictures"
      "file://${config.xdg.userDirs.videos} Videos"
      "file://${config.xdg.userDirs.download} Downloads"

      "sftp://root@192.168.69.20/ / on 192.168.69.20"
      "file://${config.home.homeDirectory}/nixconf nixconf"
      "file://${config.home.homeDirectory}/git git"
      "sftp://jwt00390@login23-g-1.hpc.itc.rwth-aachen.de/rwthfs/rz/cluster/home/jwt00390 jwt00390"
    ];
  };
}
