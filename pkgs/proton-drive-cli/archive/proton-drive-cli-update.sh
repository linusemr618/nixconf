#!/usr/bin/env bash
# passthru.updateScript for pkgs/proton-drive-cli.nix.
#
# Run from the nixconf repo root:
#   $(nix build .#proton-drive-cli.updateScript --no-link --print-out-paths)
#
# Bumps to the newest `cli/vX.Y.Z` tag on ProtonDriveApps/sdk, then
# refreshes the two hashes the derivation needs (the fetchFromGitHub `src`
# and the `node_modules` fixed-output derivation) by setting each to a
# deliberately-wrong hash and reading the real one back out of the
# resulting "hash mismatch" build error - the same trick you'd use by
# hand, just scripted. `jsSdkVersion` is best-effort (read from
# client/js/package.json at the new tag); it's a compatibility pick, not a
# straight version bump, so double-check it before committing.
set -euo pipefail

nix_file="pkgs/proton-drive-cli.nix"
if [[ ! -f "$nix_file" ]]; then
  echo "proton-drive-cli-update.sh: run from the nixconf repo root (no $nix_file here)" >&2
  exit 1
fi

fake_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

current_version=$(grep -m1 '^\s*version = "' "$nix_file" | sed -E 's/.*"([^"]+)".*/\1/')
latest_version=$(
  git ls-remote --tags https://github.com/ProtonDriveApps/sdk.git 'cli/v*' \
    | sed -E 's#.*refs/tags/cli/v##' \
    | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
    | sort -V | tail -1
)

if [[ -z "$latest_version" ]]; then
  echo "proton-drive-cli-update.sh: couldn't find any cli/v* tags upstream" >&2
  exit 1
fi

if [[ "$latest_version" == "$current_version" ]]; then
  echo "proton-drive-cli: already at newest version ($current_version)"
  exit 0
fi
echo "proton-drive-cli: $current_version -> $latest_version"

# Best-effort jsSdkVersion: the SDK version client/js was at when this cli
# tag was cut.
js_sdk_version=$(
  curl -sf "https://raw.githubusercontent.com/ProtonDriveApps/sdk/cli/v${latest_version}/client/js/package.json" \
    | grep -m1 '"version"' \
    | sed -E 's/.*"version":[[:space:]]*"([^"]+)".*/\1/'
)
if [[ -z "$js_sdk_version" ]]; then
  echo "proton-drive-cli-update.sh: couldn't read client/js/package.json at cli/v${latest_version}; leaving jsSdkVersion untouched, check it by hand" >&2
fi

sed -i -e "s/version = \"${current_version}\";/version = \"${latest_version}\";/" "$nix_file"
if [[ -n "$js_sdk_version" ]]; then
  sed -i -e "s/jsSdkVersion = \"[^\"]*\";/jsSdkVersion = \"${js_sdk_version}\";/" "$nix_file"
fi

# Reset both hashes to a known-wrong value; each gets fixed up as we go.
sed -i \
  -e "s#hash = \"sha256-[^\"]\\+\";#hash = \"${fake_hash}\";#" \
  -e "s#outputHash = \"sha256-[^\"]\\+\";#outputHash = \"${fake_hash}\";#" \
  "$nix_file"

# Extracts the real hash from a `nix build` hash-mismatch error, or exits
# with the failing build's output if it failed for some other reason.
next_hash_from_failed_build() {
  local log
  if log=$(nix build .#proton-drive-cli --no-link 2>&1); then
    echo "proton-drive-cli-update.sh: build unexpectedly succeeded with a placeholder hash still in place" >&2
    exit 1
  fi
  local got
  got=$(printf '%s\n' "$log" | sed -n 's/^[[:space:]]*got:[[:space:]]*//p' | head -1)
  if [[ -z "$got" ]]; then
    echo "proton-drive-cli-update.sh: build failed, but not with a hash mismatch:" >&2
    printf '%s\n' "$log" >&2
    exit 1
  fi
  printf '%s' "$got"
}

echo "proton-drive-cli: fetching src hash..."
new_src_hash=$(next_hash_from_failed_build)
sed -i -e "s#hash = \"${fake_hash}\";#hash = \"${new_src_hash}\";#" "$nix_file"

echo "proton-drive-cli: fetching node_modules hash..."
new_node_modules_hash=$(next_hash_from_failed_build)
sed -i -e "s#outputHash = \"${fake_hash}\";#outputHash = \"${new_node_modules_hash}\";#" "$nix_file"

echo "proton-drive-cli: verifying build..."
nix build .#proton-drive-cli --no-link

echo "proton-drive-cli: updated to ${latest_version}${js_sdk_version:+ (jsSdkVersion=${js_sdk_version})}"
if [[ -z "$js_sdk_version" ]]; then
  echo "proton-drive-cli: jsSdkVersion was left as-is, verify it manually"
fi
