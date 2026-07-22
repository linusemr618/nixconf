{inputs, ...}: {
  flake.modules.nixos.minimal = {
    config,
    pkgs,
    ...
  }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware = {
      enableAllFirmware = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
    services.fwupd.enable = true;

    time.timeZone = "Europe/Berlin";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
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

    imports = [inputs.home-manager.nixosModules.home-manager];
    users.users.${config.var.user.name} = {
      hashedPasswordFile = config.sops.secrets."user/password".path;
      isNormalUser = true;
      description = config.var.user.description;
      extraGroups = ["networkmanager" "wheel"];
      linger = true;
    };
    home-manager = {
      backupFileExtension = "backup";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
    sops.secrets."user/password" = {};
  };

  flake.modules.homeManager.minimal = {config, ...}: {
    home = {
      username = config.var.user.name;
      homeDirectory = "/home/${config.var.user.name}";
      stateVersion = "26.05";
    };
    systemd.user.startServices = "sd-switch";
  };
}
