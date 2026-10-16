{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.minimal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.aircrack-ng];

    # programs.appimage = {
    #   enable = true;
    #   binfmt = true;
    #   package = pkgs.appimage-run.override {
    #     extraPkgs = pkgs: [
    #         pkgs.libxshmfence
    #       ];
    #   };
    # };
    services.flatpak.enable = true;
  };

  flake.modules.homeManager.minimal = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      android-tools
      devenv
      disko
      ffmpeg-full
      file
      gcc
      git
      htop
      hping
      lm_sensors
      man-pages
      net-tools
      nil
      nixfmt
      openssh
      self.packages.${pkgs.stdenv.hostPlatform.system}.proton-drive-cli
      unzip
      usbutils
      wget
      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.proton-drive-cli = pkgs.callPackage "${inputs.nixpkgs-pr-proton-drive-cli}/pkgs/by-name/pr/proton-drive-cli/package.nix" {};
  };
}
