{
  flake.nixosModules.core = {pkgs, ...}: {
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    services.fwupd.enable = true;
    hardware = {
      enableAllFirmware = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
    console.keyMap = "de";
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    # services.openssh.enable = true;

    networking = {
      firewall = {
        allowedTCPPorts = [];
        allowedUDPPorts = [];
      };
      networkmanager = {
        enable = true;
        plugins = with pkgs; [networkmanager-openconnect];
      };
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };

    system.stateVersion = "26.05";
  };
}
