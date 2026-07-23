{inputs, ...}: {
  flake.modules.nixos.graphicalHyprland = {...}: {
    imports = [inputs.noctalia.nixosModules.default];
    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };
  flake.modules.homeManager.graphicalHyprland = {...}: {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia.enable = true;
    wayland.windowManager.hyprland.settings.exec_cmd = ["noctalia --daemon"];
  };
}
