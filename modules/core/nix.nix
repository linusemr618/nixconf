{inputs, ...}: {
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.nix-index-database.nixosModules.default];

    nixpkgs.config.allowUnfree = true;
    nix = {
      channel.enable = false;
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "ca-derivations"
          "flakes"
          "nix-command"
        ];
        substituters = ["https://nix-community.cachix.org"];
        trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
        trusted-users = ["root" "@wheel"];
        warn-dirty = false;
        flake-registry = "";
      };
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
    };

    programs.nix-ld.enable = true;

    programs.nix-index-database.comma.enable = true;
    environment.sessionVariables = {COMMA_CACHING = 0;};

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 2d --keep 10";
        dates = "hourly";
      };
      flake = "${config.flake.location}";
    };
  };
}
