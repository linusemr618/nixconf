{
  inputs,
  self,
  ...
}: {
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
    packages = {
      claude-desktop = pkgs.callPackage ../pkgs/claude-desktop.nix {};
      proton-drive-cli = pkgs.callPackage ../pkgs/proton-drive-cli.nix {};
      iso = self.nixosConfigurations.iso.config.system.build.isoImage;
    };
  };
}
