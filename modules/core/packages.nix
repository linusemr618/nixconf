{
  flake.nixosModules.core = {pkgs, ...}: {
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

  flake.homeModules.core = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      android-tools
      devenv
      gcc
      git
      net-tools
      neovim
      nil
      nixd
      openssl
      wget

      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
