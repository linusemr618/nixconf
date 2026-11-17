{inputs, ...}: {
  flake.modules.nixos.minimal = {config, ...}: {
    imports = [inputs.nix-index-database.nixosModules.default];

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [inputs.nur.overlays.default];
    };
    nix = {
      channel.enable = false;
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "ca-derivations"
          "flakes"
          "nix-command"
        ];
        nix-path = config.nix.nixPath;
        substituters = ["https://nix-community.cachix.org"];
        trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
        trusted-users = ["@wheel"];
        warn-dirty = false;
      };
    };

    programs.nix-ld.enable = true;
    programs.nix-index-database.comma.enable = true;
    environment.sessionVariables = {COMMA_CACHING = 1;};
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 2d --keep 10";
        dates = "daily";
      };
      flake = "${config.var.flake.location}";
    };
  };
}
