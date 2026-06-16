{
  flake.modules.nixos.core = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      aircrack-ng
    ];

    # programs.appimage = {
    #   enable = true;
    #   binfmt = true;
    #   package = pkgs.appimage-run.override {
    #     extraPkgs = with pkgs;
    #       pkgs: [
    #         libxshmfence
    #       ];
    #   };
    # };
    # services.flatpak.enable = true;
  };

  flake.modules.homeManager.core = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      android-tools
      devenv
      ffmpeg-full
      gcc
      git
      net-tools
      nil
      nixd
      openssl
      wget

      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
