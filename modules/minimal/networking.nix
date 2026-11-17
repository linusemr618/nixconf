{...}: {
  flake.modules.nixos.minimal = {...}: {
    networking = {
      nftables.enable = true;
      networkmanager.enable = true;
    };
  };
}
