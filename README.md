# nixconf

My personal NixOS configuration

## Installation

### Setup

```bash
nix-shell -p git && git clone https://github.com/linusemr618/nixconf && exit
cd nixconf
nix-shell
```

### Build and switch to the configuration

With an authorised host ssh key:

```bash
sudo nixos-rebuild switch --flake .#laptop
```

Without authorisation (every secret will be "changeme"):

```bash
sudo EMPTY_SECRETS=1 nixos-rebuild switch --impure --flake .#laptop
```

### Build an ISO file

```bash
EMPTY_SECRETS=1 nix build --impure .#iso
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
- [ ] backup solution (restic)
- [ ] disko
- [ ] impermanence
