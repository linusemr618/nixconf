{
  flake.modules.nixos.graphicalNiri = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      noctalia-shell
    ];
  };
}
