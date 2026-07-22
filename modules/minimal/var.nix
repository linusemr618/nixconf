let
  myVar = {
    config,
    lib,
    ...
  }: {
    options = with lib; {
      var = {
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
          default = "/home/${config.var.user.name}/nixconf";
        };
      };
    };
  };
in
  {...}: {
    flake.modules.nixos.minimal = myVar;
    flake.modules.homeManager.minimal = myVar;
  }
