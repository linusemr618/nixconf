{...}: {
  flake.modules.nixos.base = {pkgs, ...}: {
    environment.systemPackages = [pkgs.aircrack-ng];
  };

  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = with pkgs; [
      disko
      file
      htop
      lm_sensors
      man-pages
      net-tools
      unzip
      usbutils
      wget
    ];
  };
}
