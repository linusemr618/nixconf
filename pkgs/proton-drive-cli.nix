{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  writableTmpDirAsHomeHook,
  makeWrapper,
  libsecret,
  glib,
}: let
  version = "0.7.0";
  jsSdkVersion = "0.20.0"; # SDK version at cli/v${version}, see client/js
  rev = "ca11470feb2554930e495684681dba4ff3b50b4c"; # tag cli/v${version}

  src = fetchFromGitHub {
    owner = "ProtonDriveApps";
    repo = "sdk";
    inherit rev;
    hash = "sha256-RI04B9Yd7075LB7cO4p7IYwbnO+O8gryzNJxbijcxLs=";
  };

  # The upstream README asks for Bun >=1.3.14 (mainly for the thumbnail
  # generation API); nixpkgs' bun is a patch version behind. Deliberately
  # NOT pinning our own 1.3.14 build here: `oven-sh/bun`'s official
  # bun-v1.3.14 release has a `bun build --compile` regression that
  # produces a binary segfaulting on startup for a bundle this size
  # (reproduced with and without --bytecode; nixpkgs' 1.3.13 compiles a
  # working binary from the exact same sources). `Bun.secrets`, which the
  # CLI needs for its default credentials store, already works on 1.3.13;
  # only thumbnail generation on upload may be affected, and that's
  # user-facing-optional (`filesystem upload --skip-thumbnails`).
  # `cli/` depends on its two sibling workspace packages via tsconfig `paths`
  # (bundled straight from their TypeScript sources, no separate build step
  # needed) and on npm packages pinned in `cli/bun.lock`. Fetch the latter in
  # a fixed-output derivation so the actual build stays network-free.
  node_modules = stdenv.mkDerivation {
    pname = "proton-drive-cli-node_modules";
    inherit version src;

    nativeBuildInputs = [bun writableTmpDirAsHomeHook];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      cd cli
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
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
      bun add --no-progress --no-save '@xmldom/xmldom@^0.9.10' 'exifreader@^4.39.1'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R node_modules $out/
      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-ijjOOuWn9OJCXRL0bSYa14Yo8YehuBIBMIcnCvpfOSU=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
  stdenv.mkDerivation {
    pname = "proton-drive-cli";
    inherit version src;

    nativeBuildInputs = [bun makeWrapper];

    configurePhase = ''
      runHook preConfigure
      cp -R ${node_modules}/node_modules cli/node_modules
      chmod -R u+w cli/node_modules
      # cli/tsconfig.json redirects the two sibling workspace packages
      # straight to their TypeScript sources (bypassing node_modules), but
      # those sources still import ordinary npm packages (ttag, ky, ...)
      # by bare specifier. Module resolution walks up from each source
      # file looking for the nearest node_modules, and neither sibling
      # directory has one of its own, so point both at cli's.
      ln -s "$PWD/cli/node_modules" client/js/node_modules
      ln -s "$PWD/cli/node_modules" incubating/account/js/node_modules
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      cd cli
      # Equivalent to `bun run build` (scripts/build-cli.mjs), but without
      # --bytecode (see the note on Bun's version above) and with the
      # version lookup inlined directly, since the script's `git tag`-based
      # fallback wouldn't work anyway (fetchFromGitHub drops .git).
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
      # Bun's runtime dlopens libsecret at call time for `Bun.secrets`
      # (used for the default `keychain` credentials store).
      wrapProgram $out/bin/proton-drive \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libsecret glib]}

      runHook postInstall
    '';

    # `bun build --compile` embeds the JS bundle in the ELF; stripping
    # removes it and leaves a binary that just runs plain `bun`.
    dontStrip = true;

    meta = {
      description = "Proton Drive command-line client";
      homepage = "https://github.com/ProtonDriveApps/sdk/tree/main/cli";
      changelog = "https://github.com/ProtonDriveApps/sdk/blob/main/cli/CHANGELOG.md";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux" "aarch64-linux"];
      mainProgram = "proton-drive";
    };
  }
