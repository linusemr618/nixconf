# nixconf

My personal NixOS configuration

## Installation

### Setup

```bash
nix-shell -p git --run "git clone https://github.com/linusemr618/nixconf"
cd nixconf
nix-shell
```

### Build and switch to the configuration

```bash
sudo nixos-rebuild switch --flake .#laptop
```

### Ephemeral root (laptop)

`/` is replaced by an empty btrfs subvolume on every boot; the previous root is kept in
`@old_roots/<timestamp>` for 30 days. Only paths declared in
`modules/hosts/laptop/impermanence.nix` survive (stored on `/persist`). `/home` and `/nix` are untouched.
Run `fs-diff` to see which files on `/` would be lost on the next reboot.

Migrating an existing install (one-time):

```bash
./scripts/migrate-impermanence.sh   # creates @persist and copies the declared state into it
sudo nixos-rebuild boot --flake .#laptop && reboot
```

On a fresh disko install, copy the SSH host key used by sops to `/mnt/persist/etc/ssh/` before rebooting.

### Build an ISO file

```bash
nix build .#iso
```

## To-Dos:

- [x] devShell
- [x] use xdg
- [x] use nh
- [x] zed
- [x] firewall
- [x] (switch to niri or hyprland)
- [x] docker
- [x] ~~npins (vic/den)~~
- [x] Restructure graphics and enable 32bit
- [x] check for default gnome options (see niri-flake)
- [x] research firmware options
- [x] tmux (mouse support & continuum)
- [x] maybe remove unnecessary fish plugins
- [x] geary
- [x] sops-nix
- [x] seahorse integration
- [x] wifi passwords
- [x] vpn
- [x] structure network stuff
- [x] Proton Mail Bridge
- [x] kde connect
- [x] btrfs snapshots
- [x] maybe element desktop
- [x] Librewolf/Zen
- [x] disko
- [x] fix vpns
- [ ] backup solution (restic or proton rclone)
- [x] impermanence (btrfs root rollback + preservation)
