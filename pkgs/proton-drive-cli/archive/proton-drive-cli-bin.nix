{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  libsecret,
  glib,
}: let
  version = "0.8.0";

  sources = {
    x86_64-linux = {
      arch = "linux-x64";
      hash = "sha256-lEPXcXGciSeQ2xfm8C7Nma18U1kzKfOmfHdnfc5XdzU=";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      hash = "sha256-CGvEdApzy460kA1Rg2v/DDMt2jkLPweA2fgF/VwqX+M=";
    };
  };

  source = sources.${stdenv.hostPlatform.system} or (throw "proton-drive-cli: unsupported platform ${stdenv.hostPlatform.system}");
in
  stdenv.mkDerivation {
    pname = "proton-drive-cli";
    inherit version;

    src = fetchurl {
      url = "https://proton.me/download/drive/cli/${version}/${source.arch}/proton-drive";
      inherit (source) hash;
    };

    dontStrip = true;
    dontUnpack = true;

    nativeBuildInputs = [autoPatchelfHook makeWrapper];

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/proton-drive
      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/proton-drive \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libsecret glib]}
    '';

    meta = {
      description = "Proton Drive command-line client";
      homepage = "https://github.com/ProtonDriveApps/sdk/tree/main/cli";
      changelog = "https://github.com/ProtonDriveApps/sdk/blob/main/cli/CHANGELOG.md";
      license = lib.licenses.mit;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = builtins.attrNames sources;
      maintainers = [lib.maintainers.linusemr618];
      mainProgram = "proton-drive";
    };
  }
