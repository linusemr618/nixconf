{inputs, ...}: {
  flake.modules.nixos.minimal = {
    config,
    lib,
    pkgs,
    ...
  }: {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    hardware.enableAllFirmware = true;
    services.fwupd.enable = true;

    time.timeZone = "Europe/Dublin";
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
    services.xserver.xkb.layout = "de";

    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    # services.openssh.enable = true;

    imports = [inputs.home-manager.nixosModules.home-manager];
    users.users.${config.var.user.name} = {
      isNormalUser = true;
      description = config.var.user.description;
      extraGroups = ["networkmanager" "wheel"];
      linger = true;
    };
    home-manager = {
      backupFileExtension = "hmbackup";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };

  flake.modules.homeManager.minimal = {osConfig, ...}: {
    home.stateVersion = osConfig.system.stateVersion;
  };
}
