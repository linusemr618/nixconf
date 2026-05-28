{
  flake.homeModules.core = {config, ...}: {
    home.file = {
      ".ssh/id_ed25519_github.pub".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMR79taU5u7U/OJZh/Nybnf+xpbKNxljNVM7SEubbRJ ${config.user.name}@github
      '';
      ".ssh/id_ed25519_kaffeekanne.pub".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuKs5L5NCNm12JQQBkRwuv3oGC4PJRli3OMyLnL7drk ${config.user.name}@kaffeekanne
      '';
      ".ssh/id_ed25519_regapp.pub".text = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILK/kXmfQwste2m5gNj2M3Pxqv7Agl7x6ihgDjaI2Jya ${config.user.name}@regapp
      '';
    };
    sops.secrets = {
      "ssh/github" = {
        path = "/home/${config.user.name}/.ssh/id_ed25519_github";
        mode = "0400";
      };
      "ssh/kaffeekanne" = {
        path = "/home/${config.user.name}/.ssh/id_ed25519_kaffeekanne";
        mode = "0400";
      };
      "ssh/regapp" = {
        path = "/home/${config.user.name}/.ssh/id_ed25519_regapp";
        mode = "0400";
      };
    };
  };
}
