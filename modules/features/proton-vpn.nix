{inputs, ...}: {
  flake.modules.nixos.proton-vpn = {...}: {
    imports = ["${inputs.nixpkgs-pr-proton-vpn}/nixos/modules/programs/proton-vpn.nix"];
    programs.proton-vpn.gui.enable = true;
  };
}
