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
- [ ] impermanence
