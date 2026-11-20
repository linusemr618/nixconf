#!/usr/bin/env bash
# One-time migration of an existing laptop install to the ephemeral-root layout.
# Creates the @persist subvolume and copies every path listed in
# `preservation.preserveAt."/persist"` from the running system into it.
#
# Usage (as your normal user, from the repo root):
#   ./scripts/migrate-impermanence.sh
#   sudo nixos-rebuild boot --flake .#laptop && reboot
set -euo pipefail

flake=${1:-.}
device=/dev/mapper/crypted
mnt=/mnt/btrfs-top

# Evaluate as the invoking user (root can't read a git repo owned by someone else).
mapfile -t paths < <(
  nix eval --json "$flake#nixosConfigurations.laptop.config.preservation.preserveAt" \
    --apply 'p: let c = p."/persist"; in map (d: d.directory) c.directories ++ map (f: f.file) c.files' |
    nix run nixpkgs#jq -- -r '.[]'
)

echo "Paths to persist:"
printf '  %s\n' "${paths[@]}"

sudo bash -euo pipefail -s "$device" "$mnt" "${paths[@]}" <<'EOF'
device=$1 mnt=$2
shift 2
mkdir -p "$mnt"
mount -o subvol=/ "$device" "$mnt"
trap 'umount "$mnt"' EXIT

[ -e "$mnt/@persist" ] || btrfs subvolume create "$mnt/@persist"

for p in "$@"; do
  if [ -e "$p" ]; then
    cp -a --reflink=auto --parents "$p" "$mnt/@persist/"
    echo "copied  $p"
  else
    echo "missing $p (skipped)"
  fi
done
EOF

echo "Done. Now run: sudo nixos-rebuild boot --flake $flake#laptop && reboot"
