{
  inputs,
  self,
  ...
}: {
  flake.homeModules.core = {pkgs, ...}: {
    programs.github-copilot-cli = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myCopilot;
    };
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
    packages.myCopilot = pkgs.github-copilot-cli.overrideAttrs (oldAttrs: {
      # Append libsecret to the existing buildInputs on Linux
      buildInputs =
        (oldAttrs.buildInputs or [])
        ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          pkgs.libsecret
        ];

      # Ensure autoPatchelfHook actually links keytar.node against libsecret
      # instead of ignoring it as missing.
      autoPatchelfIgnoreMissingDeps = false;
    });
  };
}
