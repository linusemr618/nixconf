{
  inputs,
  self,
  ...
}: {
  flake.homeModules.core = {pkgs, ...}: {
    home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.myCopilot];
  };
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    packages.myCopilot = pkgs.callPackage ({
      lib,
      buildFHSEnv,
      github-copilot-cli,
      ...
    }:
      buildFHSEnv {
        name = "copilot";

        targetPkgs = pkgs:
          with pkgs; [
            github-copilot-cli
            libsecret

            # NOTE FROM A HUMAN
            # glib is absolutely required here because libsecret depends on it and keyring support is broken without it
            # Even though I find it strange that it doesn't get pulled automatically and has to be specified manually
            glib
          ];

        # Dynamically points to the main executable of the GitHub Copilot CLI package
        runScript = lib.getExe github-copilot-cli;

        meta = with lib; {
          description = "GitHub Copilot CLI executed within an FHS-compatible sandbox";
          homepage = "https://github.com/github/copilot-cli";
          license = licenses.unfree;
          platforms = platforms.linux;
        };
      }) {};
  };
}
