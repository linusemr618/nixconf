{...}: {
  flake.modules.homeManager.minimal = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [rclone];
    systemd.user = {
      services.proton-backup = {
        Unit = {
          Description = "Daily Backup to Proton Drive via rclone";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.rclone}/bin/rclone sync /home/${config.var.user.name}/Documents proton:BackupFolder -v";
        };
      };
      timers.proton-backup = {
        Unit = {
          Description = "Timer to run Proton Drive backup daily";
        };
        Timer = {
          OnCalendar = "*-*-* 01:00:00"; # Runs at 3 AM daily
          Persistent = true;
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
