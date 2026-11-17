{self, ...}: {
  flake.modules.homeManager.hostsLaptop = {
    config,
    osConfig,
    ...
  }: {
    home.file = {
      ".ssh/id_ed25519.pub".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhGZTpuXrLUoXzA3u2PIr9Khq7ngrk1JdtMIEIg/3pX ${osConfig.var.user.name}@${osConfig.networking.hostName}
      '';
    };
    sops.secrets = {
      "ssh/private_key" = {
        sopsFile = self + "/secrets/${osConfig.networking.hostName}.yaml";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0400";
      };
    };
  };
}
