{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.flake) modules;

  mkHost = name: features: let
    all = lib.unique (["hosts${lib.toSentenceCase name}"] ++ features);
    unknown = lib.filter (f: !(modules.nixos ? ${f} || modules.homeManager ? ${f})) all;
    pick = class: lib.concatMap (f: lib.optional (modules.${class} ? ${f}) modules.${class}.${f}) all;
  in
    assert lib.assertMsg (unknown == []) "host '${name}': unknown feature(s): ${toString unknown}";
      inputs.nixpkgs.lib.nixosSystem {
        modules =
          pick "nixos"
          ++ [
            ({config, ...}: {
              networking.hostName = lib.mkDefault name;
              home-manager.users.${config.var.user.name}.imports = pick "homeManager";
            })
          ];
      };
in {
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    default = {};
  };

  config.flake.nixosConfigurations = lib.mapAttrs mkHost config.hosts;
}
