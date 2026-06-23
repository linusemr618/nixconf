{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];
  systems = ["x86_64-linux"];
  perSystem = {pkgs, ...}: {
    devShells.default = import ../shell.nix {inherit pkgs;};
    formatter = pkgs.alejandra;
  };
}
