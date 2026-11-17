{self, ...}: {
  flake.modules.nixos.hostsLaptop = {config, ...}: {
    sops.secrets."user/password" = {
      sopsFile = self + "/secrets/${config.networking.hostName}.yaml";
      neededForUsers = true;
    };
    users.users.${config.var.user.name}.hashedPasswordFile = config.sops.secrets."user/password".path;
  };
}
