{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];
  systems = ["x86_64-linux"];
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    devShells.default = import ../shell.nix {inherit pkgs;};
    formatter = pkgs.alejandra;
  };
}
