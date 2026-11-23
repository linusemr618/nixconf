{inputs, ...}: {
  flake.modules.nixos.desktopHyprland = {...}: {
    imports = [inputs.noctalia.nixosModules.default];
    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };
  flake.modules.homeManager.desktopHyprland = {...}: {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia.enable = true;
    wayland.windowManager.hyprland.settings.exec_cmd = ["noctalia --daemon"];
  };
}
