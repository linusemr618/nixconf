{...}: {
  flake.modules.homeManager.hostsLaptop = {config, ...}: {
    home.file = {
      ".ssh/id_ed25519.pub".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhGZTpuXrLUoXzA3u2PIr9Khq7ngrk1JdtMIEIg/3pX ${config.var.user.name}@${config.var.host.name}
      '';
    };
    sops.secrets = {
      "${config.var.host.name}/ssh/private_key" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0400";
      };
    };
  };
}
