{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
}: let
  version = "0.7.0";

  sources = {
    x86_64-linux = {
      url = "https://proton.me/download/drive/cli/${version}/linux-x64/proton-drive";
      hash = "sha256-Tjx0p6JdoA16DKnuIjqbewsjjaNXq2/P7gSlwxPd9NE=";
    };
    aarch64-linux = {
      url = "https://proton.me/download/drive/cli/${version}/linux-arm64/proton-drive";
      hash = "sha256-XW7TKTy1gb/pL8ZUStmzLA24MgJtQ4wX3vKPXNQ9ZsI=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
    or (throw "proton-drive-cli: unsupported system ${stdenv.hostPlatform.system}");

  # Proton's binary is a `bun build --compile` executable: the JS bundle is
  # embedded in the ELF and self-verified against the file's own bytes at
  # startup. Running it through autoPatchelfHook rewrites the ELF (new
  # interpreter/rpath) and breaks that self-check, silently falling back to
  # plain `bun` behaviour instead of running proton-drive. So it must stay
  # byte-for-byte untouched; buildFHSEnv gives it a standard /lib64 loader
  # instead of patching the binary.
  unwrapped = stdenv.mkDerivation {
    pname = "proton-drive-cli-unwrapped";
    inherit version;

    src = fetchurl {
      inherit (source) url hash;
    };

    dontUnpack = true;
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/proton-drive
      runHook postInstall
    '';
  };
in
  buildFHSEnv {
    name = "proton-drive";
    targetPkgs = pkgs: [unwrapped pkgs.libsecret];
    runScript = "proton-drive";

    meta = {
      description = "Proton Drive command-line client";
      homepage = "https://proton.me/drive";
      license = lib.licenses.unfree;
      platforms = builtins.attrNames sources;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      mainProgram = "proton-drive";
    };
  }
