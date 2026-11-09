{...}: {
  flake.modules.nixos.minimal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.aircrack-ng];
  };

  flake.modules.homeManager.minimal = {pkgs, ...}: {
    home.packages = with pkgs; [
      alejandra
      android-tools
      devenv
      disko
      file
      gcc
      gh
      htop
      hping
      lm_sensors
      man-pages
      net-tools
      nil
      nixfmt
      nixpkgs-reviewFull
      unzip
      usbutils
      wget
      (python3.withPackages (ps: [ps.tkinter]))
    ];
  };
}
