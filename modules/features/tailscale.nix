{...}: {
  flake.modules.nixos.tailscale = {config, ...}: {
    services.tailscale = {
      enable = true;
      disableUpstreamLogging = true;
      extraSetFlags = [
        "--accept-routes"
        "--operator=${config.var.user.name}"
      ];
      openFirewall = true;
      useRoutingFeatures = "client";
    };
  };
  #flake.modules.homeManager.optional = {...}: {
  #  #home.packages = [pkgs.tailscale];
  #  services.tailscale-systray.enable = true;
  #};
}
