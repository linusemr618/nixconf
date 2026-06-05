let
  myOptions = {
    config,
    lib,
    ...
  }: {
    options = with lib; {
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
        default = "/home/${config.user.name}/nixconf";
      };
    };
  };
in {
  flake.modules.nixos.core = myOptions;
  flake.modules.homeManager.core = myOptions;
}
