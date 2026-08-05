{...}: {
  flake.modules.nixos.graphical = {...}: {
    programs.ausweisapp = {
      enable = true;
      openFirewall = true;
    };
  };
}
