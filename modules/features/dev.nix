{...}: {
  flake.modules.nixos.dev = {pkgs, ...}: {
    environment.systemPackages = [pkgs.aircrack-ng];
  };

  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      android-tools
      devenv
      gcc
      gh
      hping
      nil
      nixd
      nixfmt
      nixpkgs-reviewFull
      (python3.withPackages (ps: [ps.tkinter]))
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
