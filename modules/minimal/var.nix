{...}: {
  flake.modules.nixos.minimal = {
    config,
    lib,
    ...
  }: {
    options.var = {
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
}
