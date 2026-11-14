{...}: {
  flake.modules.homeManager.hostsLaptop = {
    config,
    pkgs,
    ...
  }: let
    home = "/home/${config.var.user.name}";
  in {
    home.packages = [pkgs.rclone];
    sops.secrets."${config.var.host.name}/backup/restic_password" = {};
    services.restic = {
      enable = true;
      backups.proton = {
        repository = "rclone:protondrive:backups/${config.var.host.name}-restic";
        passwordFile = config.sops.secrets."${config.var.host.name}/backup/restic_password".path;
        initialize = true;
        paths = [home];
        exclude = [
          "${home}/.*"
          "${home}/Downloads"
          "${home}/backups"
          "${home}/git"
          "${home}/nixconf"
          ".venv"
          "__pycache__"
          "node_modules"
          "target"
          "venv"
        ];
        extraBackupArgs = ["--exclude-caches" "--pack-size=64"];
        pruneOpts = ["--keep-daily 7" "--keep-weekly 4" "--keep-monthly 12" "--keep-yearly 1"];
        checkOpts = ["--read-data-subset=5%"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
    };
    systemd.user.services.restic-backups-proton = {
      Unit = {
        After = ["sops-nix.service"];
        # The timer can fire right after login, before the network is up
        StartLimitIntervalSec = "1d";
        StartLimitBurst = 5;
      };
      Service = {
        Restart = "on-failure";
        RestartSec = "15min";
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    };
  };
}
