{...}: {
  flake.modules.nixos.sabnzbd = {config, ...}: let
    owner = config.services.sabnzbd.user;
  in {
    sops.secrets = {
      "sabnzbd/newshosting_username" = {inherit owner;};
      "sabnzbd/newshosting_password" = {inherit owner;};
    };
    services.sabnzbd = {
      enable = true;
      secretValues = {
        "@newshosting_username@" = config.sops.secrets."sabnzbd/newshosting_username".path;
        "@newshosting_password@" = config.sops.secrets."sabnzbd/newshosting_password".path;
      };
      settings = {
        misc.port = 30055;
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
