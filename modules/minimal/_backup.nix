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
          Description = "Proton Drive backup";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.rclone}/bin/rclone sync /home/${config.var.user.name}/Documents protondrive:BackupFolder -v";
        };
      };
      timers.proton-backup = {
        Unit = {
          Description = "Run Proton Drive backup daily";
        };
        Timer = {
          OnCalendar = "*-*-* 01:00:00";
          Persistent = true;
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
