{...}: {
  flake.modules.nixos.base = {...}: {
    networking = {
      nftables.enable = true;
      networkmanager.enable = true;
    };
  };
}
