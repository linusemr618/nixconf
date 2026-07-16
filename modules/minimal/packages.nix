{
  flake.modules.nixos.minimal = {pkgs, ...}: {
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

  flake.modules.homeManager.minimal = {pkgs, ...}: {
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
      lm_sensors
      net-tools
      nil
      nixd
      #openssl
      usbutils
      wget

      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
