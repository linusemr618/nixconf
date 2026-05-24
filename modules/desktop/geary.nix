{
  flake.homeModules.desktop = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      geary
    ];
    dconf.settings."org/gnome/Geary".run-in-background = true;
    sops = {
      secrets = {
        "desktop/geary/rwth_email" = {};
        "desktop/geary/rwth_login" = {};
      };
      templates."geary.ini".content = ''
        [Metadata]
        version=1
        status=enabled

        [Account]
        ordinal=2
        label=
        prefetch_days=14
        save_drafts=true
        save_sent=true
        use_signature=false
        signature=
        sender_mailboxes=Linus Emmerich <${config.sops.placeholder."desktop/geary/rwth_email"}>;
        service_provider=other

        [Folders]
        archive_folder=Archive;
        drafts_folder=
        sent_folder=
        junk_folder=
        trash_folder=

        [Incoming]
        login=${config.sops.placeholder."desktop/geary/rwth_login"}
        remember_password=true
        host=mail.rwth-aachen.de
        port=993
        transport_security=transport
        credentials=custom

        [Outgoing]
        remember_password=true
        host=mail.rwth-aachen.de
        port=587
        transport_security=start-tls
        credentials=use-incoming
      '';
    };
    xdg.configFile."geary1/account_01/geary.ini".source =
      config.lib.file.mkOutOfStoreSymlink config.sops.templates."geary.ini".path;
  };
}
