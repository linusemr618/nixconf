{inputs, ...}: {
  flake.modules.homeManager.desktopHyprland = {...}: {
    imports = [inputs.caelestia-shell.homeManagerModules.default];
    programs.caelestia = {
      enable = true;
      cli.enable = true; # Also adds caelestia-cli to path
    };
    wayland.windowManager.hyprland.settings.exec_cmd = ["caelestia"];
  };
}
