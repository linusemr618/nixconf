{...}: {
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
    # services.flatpak.enable = true;
  };

  flake.modules.homeManager.minimal = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      android-tools
      #busybox
      cargo
      devenv
      disko
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
      unzip
      usbutils
      wget

      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
