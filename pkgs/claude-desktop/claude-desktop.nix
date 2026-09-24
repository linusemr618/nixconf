# package.nix — Claude Desktop, repackaged from Anthropic's official .deb.
#
# Anthropic publishes an apt repo at:
#   https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages
# Check that URL for the newest `Version:` / `Filename:` / `SHA256:` and bump
# the two values below when updating.
#
# Usage from your flake/configuration:
#   claude-desktop = pkgs.callPackage ./packages/claude.nix { };
#   environment.systemPackages = [ claude-desktop ];
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libcap_ng,
  libnotify,
  libseccomp,
  libsecret,
  libxcb,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
}:
stdenv.mkDerivation rec {
  pname = "claude-desktop";
  version = "1.24012.11"; # bump alongside the Packages index above

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${version}_amd64.deb";
    sha256 = "99c4bcf5e3f7d0ec44a49fbf24d7d659f2ea46e29c7ec61c77c7298522f57e76";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  # Runtime libs the bundled Electron/Chromium binary is dynamically linked
  # against (confirmed via `ldd` on the extracted binary).
  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libcap_ng # for the bundled virtiofsd helper (cowork/VM feature)
    libnotify
    libseccomp # for the bundled virtiofsd helper (cowork/VM feature)
    libsecret
    mesa # provides libgbm, libEGL, libGLESv2
    nspr
    nss
    pango
    systemd # libudev
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbcommon
  ];

  # Extract data.tar.* directly with `ar`/`tar` instead of `dpkg-deb -x`:
  # the archive restores chrome-sandbox with its setuid bit set, which
  # `tar` refuses ("Operation not permitted") when unprivileged inside the
  # Nix build sandbox. `--no-same-permissions` sidesteps that; the setuid
  # bit isn't needed anyway since postFixup runs the app with --no-sandbox.
  unpackPhase = ''
    runHook preUnpack
    ar x "$src"
    tar --no-same-permissions --no-same-owner -xf data.tar.*
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin $out/share
    cp -r usr/lib/claude-desktop $out/lib/
    cp -r usr/share/icons $out/share/
    mkdir -p $out/share/applications
    cp usr/share/applications/com.anthropic.Claude.desktop $out/share/applications/

    # Point the desktop entry's Exec at the store path instead of relying on
    # $PATH, and add the standard --enable-features workaround for Wayland/
    # Ozone that upstream Chromium apps usually need on NixOS.
    substituteInPlace $out/share/applications/com.anthropic.Claude.desktop \
      --replace-fail "Exec=claude-desktop" "Exec=$out/bin/claude-desktop"

    runHook postInstall
  '';

  # chrome-sandbox ships suid-root in the .deb (0755 owned by root, with the
  # setuid bit set by dpkg at install time via fakeroot). In the Nix store
  # nothing can set that bit, so Chromium's own sandbox can't use it here.
  # Two supported ways to get sandboxing back:
  #   1. (recommended) Add a NixOS security wrapper for chrome-sandbox, e.g.
  #        security.wrappers.claude-desktop-chrome-sandbox = {
  #          owner = "root"; group = "root"; setuid = true;
  #          source = "${claude-desktop}/lib/claude-desktop/chrome-sandbox";
  #        };
  #      and set CHROME_DEVEL_SANDBOX to that wrapper's path below.
  #   2. Run unsandboxed (what this derivation does by default) via --no-sandbox.
  #      Same tradeoff most nixpkgs Electron-from-.deb packages (vscode,
  #      slack, discord, ...) make when no security wrapper is configured.
  # Chromium's OSCrypt dlopen()s libsecret-1.so.0 by soname at runtime
  # rather than linking it, so autoPatchelf (which only patches declared ELF
  # NEEDED entries) never adds it to claude-desktop's RPATH. Without the
  # explicit LD_LIBRARY_PATH prefix below, the dlopen silently fails and
  # Claude falls back to an unencrypted/unpersisted credential store,
  # surfacing as "Install and unlock a system keyring" even when one is
  # running and unlocked. (libsecret's own rpath already resolves its glib
  # dependency, so glib doesn't need to be repeated here.)
  postFixup = ''
    makeWrapper $out/lib/claude-desktop/claude-desktop $out/bin/claude-desktop \
      --add-flags "--no-sandbox" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libsecret glib]}" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Desktop application for Claude.ai";
    homepage = "https://claude.ai";
    downloadPage = "https://claude.ai/download";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [];
    mainProgram = "claude-desktop";
  };
}
