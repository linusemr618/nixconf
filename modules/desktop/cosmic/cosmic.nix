{
  flake.nixosModules.desktopCosmic = {...}: {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.cosmic.enable = true;
      system76-scheduler.enable = true;
    };
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  };
}
