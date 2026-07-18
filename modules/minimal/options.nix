let
  myOptions = {
    config,
    lib,
    ...
  }: {
    options = with lib; {
      custom = {
        host.name = lib.mkOption {
          type = lib.types.str;
        };
        user = {
          name = mkOption {
            type = types.str;
            default = "linus";
          };
          description = mkOption {
            type = types.str;
            default = "Linus Emmerich";
          };
        };
        flake.location = mkOption {
          type = types.str;
          default = "/home/${config.custom.user.name}/nixconf";
        };
      };
    };
  };
in
  {...}: {
    flake.modules.nixos.minimal = myOptions;
    flake.modules.homeManager.minimal = myOptions;
  }
