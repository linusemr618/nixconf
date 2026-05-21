{inputs, ...}: {
  flake.nixosModules.core = {
    config,
    lib,
    #pkgs,
    ...
  }: {
    imports = [inputs.nix-index-database.nixosModules.default];

    nixpkgs.config.allowUnfree = true;
    nix = {
      channel.enable = false;
      /*
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      */
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "ca-derivations"
          "flakes"
          "nix-command"
        ];
        substituters = [
          "https://nix-community.cachix.org"
          #"https://noctalia.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          #"noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
        trusted-users = ["root" "@wheel"];
        warn-dirty = false;

        #flake-registry = "";
        #nix-path = config.nix.nixPath;
      };
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      #nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
    };

    programs.nix-ld = {
      enable = true;
      #libraries = with pkgs; [libsecret];
    };

    programs.nix-index-database.comma.enable = true;
    environment.sessionVariables = {COMMA_CACHING = 0;};

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5";
        dates = "daily";
      };
      flake = "${config.flake.location}";
    };
  };
}
