{...}: {
  flake.modules.nixos.server = {...}: {
    services.sabnzbd = {
      enable = true;
      settings.misc.port = 30055;
    };
  };

  flake.modules.nixos.serverSecrets = {config, ...}: {
    sops.secrets = {
      "sabnzbd/newshosting_username" = {owner = config.services.sabnzbd.user;};
      "sabnzbd/newshosting_password" = {owner = config.services.sabnzbd.user;};
    };
    services.sabnzbd = {
      secretValues = {
        "@newshosting_username@" = config.sops.secrets."sabnzbd/newshosting_username".path;
        "@newshosting_password@" = config.sops.secrets."sabnzbd/newshosting_password".path;
      };
      settings = {
        servers.newshosting = {
          name = "newshosting";
          displayname = "Newshosting";
          host = "news.newshosting.com";
          port = 443;
          ssl = true;
          ssl_verify = "strict";
          username = "@newshosting_username@";
          password = "@newshosting_password@";
          connections = 50;
        };
      };
    };
  };
}
