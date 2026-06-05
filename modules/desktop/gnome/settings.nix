{
  flake.modules.homeManager.desktopGnome = {
    config,
    lib,
    ...
  }: {
    dconf.settings = with lib.hm.gvariant; {
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

    sops = {
      secrets = {
        "gnome/settings/gmail_mail" = {};
        "gnome/settings/proton_mail" = {};
        "gnome/settings/rwth_login" = {};
        "gnome/settings/rwth_mail" = {};
      };
      templates."accounts.conf".content = ''
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
        Identity=${config.sops.placeholder."gnome/settings/gmail_mail"}
        PresentationIdentity=${config.sops.placeholder."gnome/settings/gmail_mail"}
        MailEnabled=true
        CalendarEnabled=true
        ContactsEnabled=true

        [Account account_1780015617_2]
        Provider=imap_smtp
        Identity=${config.sops.placeholder."gnome/settings/proton_mail"}
        PresentationIdentity=${config.sops.placeholder."gnome/settings/proton_mail"}
        Enabled=true
        EmailAddress=${config.sops.placeholder."gnome/settings/proton_mail"}
        Name=Linus Emmerich
        ImapHost=127.0.0.1:1143
        ImapUserName=${config.sops.placeholder."gnome/settings/proton_mail"}
        ImapUseSsl=false
        ImapUseTls=true
        ImapAcceptSslErrors=true
        SmtpHost=127.0.0.1:1025
        SmtpUseAuth=true
        SmtpUserName=${config.sops.placeholder."gnome/settings/proton_mail"}
        SmtpAuthLogin=false
        SmtpAuthPlain=true
        SmtpUseSsl=false
        SmtpUseTls=true
        SmtpAcceptSslErrors=true

        [Account account_1779632516_0]
        Provider=imap_smtp
        Identity=${config.sops.placeholder."gnome/settings/rwth_mail"}
        PresentationIdentity=${config.sops.placeholder."gnome/settings/rwth_mail"}
        Enabled=true
        EmailAddress=${config.sops.placeholder."gnome/settings/rwth_mail"}
        Name=Linus Emmerich
        ImapHost=mail.rwth-aachen.de
        ImapUserName=${config.sops.placeholder."gnome/settings/rwth_login"}
        ImapUseSsl=true
        ImapUseTls=false
        ImapAcceptSslErrors=true
        SmtpHost=mail.rwth-aachen.de
        SmtpUseAuth=true
        SmtpUserName=${config.sops.placeholder."gnome/settings/rwth_login"}
        SmtpAuthLogin=true
        SmtpAuthPlain=false
        SmtpUseSsl=false
        SmtpUseTls=true
        SmtpAcceptSslErrors=true
      '';
    };

    xdg.configFile."goa-1.0/accounts.conf".source = config.lib.file.mkOutOfStoreSymlink config.sops.templates."accounts.conf".path;
  };
}
