{...}: {
  flake.modules.nixos.optional = {config, ...}: {
    services.tailscale = {
      enable = true;
      disableUpstreamLogging = true;
      openFirewall = true;
      extraSetFlags = [
        "--accept-routes"
        #"--exit-node-allow-lan-access"
        "--operator=${config.var.user.name}"
      ];
      useRoutingFeatures = "client";
    };
  };
  #flake.modules.homeManager.minimal = {...}: {
  #  #home.packages = [pkgs.tailscale];
  #  services.tailscale-systray.enable = true;
  #};
}
