let
  myVar = {
    config,
    lib,
    ...
  }: {
    options = {
      var = {
        host.name = lib.mkOption {
          type = lib.types.str;
        };
        user = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "linus";
          };
          description = lib.mkOption {
            type = lib.types.str;
            default = "Linus Emmerich";
          };
        };
        flake.location = lib.mkOption {
          type = lib.types.str;
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
