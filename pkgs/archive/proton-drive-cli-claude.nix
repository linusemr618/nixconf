{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  writableTmpDirAsHomeHook,
  makeWrapper,
  versionCheckHook,
  libsecret,
  glib,
}: let
  pname = "proton-drive-cli";
  version = "0.8.0"; # tag cli/v${version}
  jsSdkVersion = "0.21.0"; # newest js/vX.Y.Z tag as of the cli release, see client/js

  src = fetchFromGitHub {
    owner = "ProtonDriveApps";
    repo = "sdk";
    tag = "cli/v${version}";
    hash = "sha256-JLyl5I3t5297LEB7ka8RUNwU0BnYy5jeLp3mywoV/YE=";
  };

  # `cli/` reaches its two sibling workspace packages through tsconfig `paths`
  # (bundled straight from their TypeScript sources, no separate build step
  # needed) and pulls ordinary npm packages from `cli/bun.lock`. Fetch the
  # latter in a fixed-output derivation so the real build stays network-free,
  # as required by nixpkgs.
  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      cd cli
      bun install \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --production

      # client/js's optional EXIF-metadata dependencies aren't reachable
      # from cli/bun.lock (bun doesn't resolve optionalDependencies of
      # "file:"-linked sibling packages), but src/additionalNodeMetadata
      # imports them unconditionally, so the bundler needs them physically
      # present. Pull them in directly; versions match client/js/package.json.
      bun add --no-progress --no-save --omit=dev '@xmldom/xmldom@^0.9.10' 'exifreader@^4.39.1'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R node_modules $out/
      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-B4TBFXG6NfTvYeF1+jK15IBDe70t7tIhJ6wGCs37nIo=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
  stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      bun
      makeWrapper
    ];

    configurePhase = ''
      runHook preConfigure

      cp -R ${node_modules}/node_modules cli/node_modules
      chmod -R u+w cli/node_modules
      # cli/tsconfig.json redirects the two sibling workspace packages
      # straight to their TypeScript sources (bypassing node_modules), but
      # those sources still import ordinary npm packages (ttag, ky, ...) by
      # bare specifier. Module resolution walks up from each source file
      # looking for the nearest node_modules, and neither sibling directory
      # has one of its own, so point both at cli's.
      ln -s "$PWD/cli/node_modules" client/js/node_modules
      ln -s "$PWD/cli/node_modules" incubating/account/js/node_modules

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      cd cli
      # Equivalent to `bun run build` (scripts/build-cli.mjs), but without
      # --bytecode: nixpkgs' bun (currently 1.3.13, a patch behind the
      # >=1.3.14 upstream asks for) produces a --bytecode binary that
      # segfaults on startup for a bundle this size, while a plain --compile
      # build from the same sources runs fine. The version defines are
      # inlined directly since the script's `git tag`-based lookup wouldn't
      # work anyway (fetchFromGitHub drops .git).
      bun build \
        --compile \
        --target=bun \
        --format=esm \
        --minify \
        --sourcemap=inline \
        --define "APP_VERSION=\"external-drive-sdkclijs@${version}\"" \
        --define "SDK_VERSION=\"js@${jsSdkVersion}\"" \
        --define SENTRY_DSN=undefined \
        src/proton-drive.ts \
        --outfile=release/proton-drive
      cd ..

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 cli/release/proton-drive $out/bin/proton-drive
      # Bun's runtime dlopens libsecret at call time for `Bun.secrets` (used
      # for the default `keychain` credentials store). libsecret's own rpath
      # already resolves its glib dependency, so it doesn't need to be
      # repeated here.
      wrapProgram $out/bin/proton-drive \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libsecret glib]}

      runHook postInstall
    '';

    # `bun build --compile` embeds the JS bundle in the ELF; stripping
    # removes it and leaves a binary that just runs plain `bun`.
    dontStrip = true;

    nativeInstallCheckInputs = [versionCheckHook];
    doInstallCheck = true;

    passthru.updateScript = ./proton-drive-cli-update.sh;

    meta = {
      description = "Proton Drive command-line client";
      homepage = "https://github.com/ProtonDriveApps/sdk/tree/main/cli";
      changelog = "https://github.com/ProtonDriveApps/sdk/blob/main/cli/CHANGELOG.md";
      license = lib.licenses.mit;
      maintainers = [
        {
          name = "Linus Emmerich";
          email = "emmerichlinus@gmail.com";
          github = "linusemr618";
        }
      ];
      platforms = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      mainProgram = "proton-drive";
    };
  }
