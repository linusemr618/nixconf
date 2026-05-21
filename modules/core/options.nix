let
  myOptions = {
    config,
    lib,
    ...
  }: {
    options.user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "linus";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Linus Emmerich";
      };
    };
    options.flake.location = lib.mkOption {
      type = lib.types.str;
      default = "/home/${config.user.name}/nixconf";
    };
  };
in {
  flake.nixosModules.core = myOptions;
  flake.homeModules.core = myOptions;
}
