{...}: {
  flake.modules.homeManager.minimal = {pkgs, ...}: {
    home.packages = with pkgs; [
      proton-pass
      proton-pass-cli
    ];

    # Use the D-Bus Secret Service (GNOME Keyring) as the keyring backend so
    # that the pass-cli encryption key persists across reboots.
    home.sessionVariables = {
      PROTON_PASS_LINUX_KEYRING = "dbus";
    };

    # Auto-load SSH keys into the agent at login.
    systemd.user.services.proton-pass-ssh-load = {
      Unit = {
        Description = "Load Proton Pass SSH keys into agent";
        After = [
          "graphical-session.target"
          "gnome-keyring-daemon.service"
          "ssh-agent.service"
        ];
      };
      Service = {
        Type = "oneshot";
        Environment = [
          "PROTON_PASS_LINUX_KEYRING=dbus"
          "SSH_AUTH_SOCK=%t/ssh-agent"
        ];
        ExecStart = "${pkgs.proton-pass-cli}/bin/pass-cli ssh-agent load";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
