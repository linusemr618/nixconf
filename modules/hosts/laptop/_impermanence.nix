# Ephemeral root: on every boot the btrfs subvolume `@` is moved to
# `@old_roots/<timestamp>` (kept for 30 days) and replaced by an empty one.
# Anything that should survive a reboot lives on `/persist` and is mapped back
# into place by `preservation`. `/home` and `/nix` are separate subvolumes and
# are not affected.
{inputs, ...}: {
  flake.modules.nixos.hostsLaptop = {
    lib,
    pkgs,
    ...
  }: let
    persist = "/persist";
    device = "/dev/mapper/crypted";
  in {
    imports = [inputs.preservation.nixosModules.default];

    fileSystems.${persist}.neededForBoot = true;

    # preservation needs systemd-initrd, which is the only initrd on current nixpkgs.
    boot.initrd.systemd = {
      services.rollback-root = {
        description = "Replace btrfs root subvolume with an empty one";
        wantedBy = ["initrd.target"];
        requires = ["dev-mapper-crypted.device"];
        after = [
          "dev-mapper-crypted.device"
          "systemd-cryptsetup@crypted.service"
          # Never touch the root before a possible resume from hibernation.
          "systemd-hibernate-resume.service"
        ];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = let
          btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
          find = "${pkgs.findutils}/bin/find";
        in ''
          mkdir -p /btrfs_tmp
          mount -t btrfs -o subvol=/ ${device} /btrfs_tmp

          if [ -e /btrfs_tmp/@ ]; then
            mkdir -p /btrfs_tmp/@old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%d_%H-%M-%S")
            mv /btrfs_tmp/@ "/btrfs_tmp/@old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(${btrfs} subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            ${btrfs} subvolume delete "$1"
          }

          for i in $(${find} /btrfs_tmp/@old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
          done

          ${btrfs} subvolume create /btrfs_tmp/@
          umount /btrfs_tmp
        '';
      };
    };

    preservation = {
      enable = true;
      preserveAt.${persist} = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            file = "/var/lib/systemd/random-seed";
            how = "symlink";
            inInitrd = true;
            configureParent = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key";
            how = "symlink";
            configureParent = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key.pub";
            how = "symlink";
            configureParent = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key";
            how = "symlink";
            configureParent = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key.pub";
            how = "symlink";
            configureParent = true;
          }
        ];
        directories = [
          {
            directory = "/var/lib/nixos"; # uid/gid allocations
            inInitrd = true;
          }
          "/var/log"
          "/var/lib/systemd/timers"
          "/var/lib/systemd/coredump"
          "/var/lib/systemd/rfkill"
          "/var/lib/systemd/backlight"

          {
            directory = "/etc/NetworkManager/system-connections";
            mode = "0700";
          }
          "/var/lib/NetworkManager"
          {
            directory = "/var/lib/bluetooth";
            mode = "0700";
          }
          {
            directory = "/var/lib/tailscale";
            mode = "0700";
          }

          "/var/lib/AccountsService"
          "/var/lib/boltd"
          {
            directory = "/var/lib/colord";
            user = "colord";
            group = "colord";
          }
          {
            directory = "/var/lib/fwupd";
            user = "fwupd-refresh";
            group = "fwupd-refresh";
          }
          "/var/lib/power-profiles-daemon"
          "/var/lib/upower"
          "/var/lib/cups"
          "/var/lib/libvirt"
        ];
      };
    };

    # machine-id is persisted, so committing a transient one is pointless (and would fail).
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

    # Activation runs before tmpfiles creates the /etc/ssh symlinks, so read the key directly.
    sops.age.sshKeyPaths = lib.mkForce ["${persist}/etc/ssh/ssh_host_ed25519_key"];

    # /etc is rebuilt on every boot anyway; make users fully declarative.
    users.mutableUsers = false;

    # sudo would otherwise lecture on every first use after a reboot.
    security.sudo.extraConfig = "Defaults lecture = never";

    environment.systemPackages = [
      # List files on / that are not persisted: `fs-diff`
      (pkgs.writeShellScriptBin "fs-diff" ''
        sudo ${pkgs.findutils}/bin/find / -xdev \( -path /tmp -o -path /var/tmp -o -path /root/.cache \) -prune -o -type f -print \
          | grep -v -e '^/etc/static' | sort
      '')
    ];
  };
}
