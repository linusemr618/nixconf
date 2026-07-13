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
      cargo
      devenv
      ffmpeg-full
      fh
      file
      gcc
      git
      htop
      hping
      net-tools
      nil
      nixd
      openssl
      usbutils
      wget

      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
