{inputs, ...}: {
  flake.nixosModules.core = {config, ...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    users.users.${config.user.name} = {
      isNormalUser = true;
      description = config.user.description;
      extraGroups = ["networkmanager" "wheel"];
      linger = true;
    };
    home-manager = {
      backupFileExtension = "backup";
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };

  flake.homeModules.core = {config, ...}: {
    home = {
      username = config.user.name;
      homeDirectory = "/home/${config.user.name}";
      stateVersion = "26.05";
    };
    systemd.user.startServices = "sd-switch";
  };
}
