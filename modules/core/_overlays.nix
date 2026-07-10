{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.core = {...}: {
    nixpkgs.overlays = lib.optionals (inputs ? myNixpkgs) [
      (final: prev: {gnomeExtensions = prev.gnomeExtensions // {forge = inputs.myNixpkgs.legacyPackages.${prev.stdenv.hostPlatform.system}.gnomeExtensions.forge;};})
    ];
  };
}
