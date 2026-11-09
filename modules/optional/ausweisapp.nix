{...}: {
  flake.modules.nixos.optional = {...}: {
    programs.ausweisapp = {
      enable = true;
      openFirewall = true;
    };
  };
}
