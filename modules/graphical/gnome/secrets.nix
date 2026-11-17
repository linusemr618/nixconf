{...}: {
  flake.modules.homeManager.graphicalGnomeSecrets = {config, ...}: {
    sops = {
      secrets = {
        "gnome/gmail_mail" = {};
        "gnome/proton_mail" = {};
        "gnome/rwth_login" = {};
        "gnome/rwth_mail" = {};
        "gnome/ucd_mail" = {};
      };
      templates."accounts.conf" = {
        content = ''
          [Account account_1779291630_0]
          Provider=owncloud
          Identity=linusemmerich
          PresentationIdentity=linusemmerich@cloud.kaffeekanne.org
          Uri=https://cloud.kaffeekanne.org:443/remote.php/webdav/
          FilesEnabled=true
          CalendarEnabled=true
          CalDavUri=https://cloud.kaffeekanne.org:443/remote.php/dav/
          ContactsEnabled=true
          CardDavUri=https://cloud.kaffeekanne.org:443/remote.php/dav/
          AcceptSslErrors=false

          [Account account_1779555501_0]
          Provider=google
          Identity=${config.sops.placeholder."gnome/gmail_mail"}
          PresentationIdentity=${config.sops.placeholder."gnome/gmail_mail"}
          MailEnabled=true
          CalendarEnabled=true
          ContactsEnabled=true

          [Account account_1780015617_2]
          Provider=imap_smtp
          Identity=${config.sops.placeholder."gnome/proton_mail"}
          PresentationIdentity=${config.sops.placeholder."gnome/proton_mail"}
          Enabled=true
          EmailAddress=${config.sops.placeholder."gnome/proton_mail"}
          Name=Linus Emmerich
          ImapHost=127.0.0.1:1143
          ImapUserName=${config.sops.placeholder."gnome/proton_mail"}
          ImapUseSsl=false
          ImapUseTls=true
          ImapAcceptSslErrors=true
          SmtpHost=127.0.0.1:1025
          SmtpUseAuth=true
          SmtpUserName=${config.sops.placeholder."gnome/proton_mail"}
          SmtpAuthLogin=false
          SmtpAuthPlain=true
          SmtpUseSsl=false
          SmtpUseTls=true
          SmtpAcceptSslErrors=true

          [Account account_1779632516_0]
          Provider=imap_smtp
          Identity=${config.sops.placeholder."gnome/rwth_mail"}
          PresentationIdentity=${config.sops.placeholder."gnome/rwth_mail"}
          Enabled=true
          EmailAddress=${config.sops.placeholder."gnome/rwth_mail"}
          Name=Linus Emmerich
          ImapHost=mail.rwth-aachen.de
          ImapUserName=${config.sops.placeholder."gnome/rwth_login"}
          ImapUseSsl=true
          ImapUseTls=false
          ImapAcceptSslErrors=true
          SmtpHost=mail.rwth-aachen.de
          SmtpUseAuth=true
          SmtpUserName=${config.sops.placeholder."gnome/rwth_login"}
          SmtpAuthLogin=true
          SmtpAuthPlain=false
          SmtpUseSsl=false
          SmtpUseTls=true
          SmtpAcceptSslErrors=true

          [Account account_1781685342_0]
          Provider=owncloud
          Identity=EmmeriLi
          PresentationIdentity=EmmeriLi@wolke.netzbegruenung.de
          Uri=https://wolke.netzbegruenung.de:443/remote.php/webdav/
          FilesEnabled=true
          CalendarEnabled=true
          CalDavUri=https://wolke.netzbegruenung.de:443/remote.php/dav/
          ContactsEnabled=true
          CardDavUri=https://wolke.netzbegruenung.de:443/remote.php/dav/
          AcceptSslErrors=false

          [Account account_1788127109_0]
          Provider=google
          Identity=${config.sops.placeholder."gnome/ucd_mail"}
          PresentationIdentity=${config.sops.placeholder."gnome/ucd_mail"}
          MailEnabled=true
          CalendarEnabled=true
          ContactsEnabled=true
        '';
        path = "${config.xdg.configHome}/goa-1.0/accounts.conf";
      };
    };
  };
}
