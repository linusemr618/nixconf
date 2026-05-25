{
  flake.nixosModules.core = {
    config,
    lib,
    pkgs,
    ...
  }: let
    wifiNetworks = [
      "ELI"
      "Kaffeekanne"
      "GRUENE"
      "Vodafone-2085"
      "WLAN-770356_EXT2.4G"
      "VDSt-WLAN"
      "AP23-Main"
    ];
    mkWifiProfile = ssid: {
      connection = {
        id = ssid;
        type = "wifi";
      };
      wifi.ssid = ssid;
      wifi-security = {
        key-mgmt = "sae";
        psk = "$WIFI_PSK_${ssid}";
      };
    };
  in {
    networking = {
      firewall = {
        allowedTCPPorts = [];
        allowedUDPPorts = [];
      };
      networkmanager = {
        enable = true;
        ensureProfiles = {
          environmentFiles = [config.sops.secrets."networking/env".path];
          profiles =
            lib.genAttrs wifiNetworks mkWifiProfile
            // {
              "Kaffeekanne_P" = {
                connection = {
                  id = "Kaffeekanne_P";
                  type = "wifi";
                  autoconnect = false;
                };
                wifi.ssid = "Kaffeekanne";
                wifi-security = {
                  key-mgmt = "sae";
                  psk = "$WIFI_PSK_Kaffeekanne_P";
                };
              };
              "eduroam" = {
                connection = {
                  id = "eduroam";
                  type = "wifi";
                };
                wifi.ssid = "eduroam";
                wifi-security.key-mgmt = "wpa-eap";
                "802-1x" = {
                  eap = "pwd";
                  identity = "$WIFI_IDENTITY_eduroam";
                  password = "$WIFI_PASSWORD_eduroam";
                };
              };
              "wg_Kaffeekanne" = {
                connection = {
                  id = "wg_Kaffeekanne";
                  type = "wireguard";
                  interface-name = "wg_Kaffeekanne";
                  autoconnect = false;
                };
                wireguard = {
                  listen-port = 51820;
                  private-key = "$VPN_PRIVATE_KEY_wg_Kaffeekanne";
                };
                "wireguard-peer.JW/FlZp2O05ragkAoFD/h6TXaw8h1hFhSI0USUEWSkQ=" = {
                  endpoint = "pfeih0lstx4qf2w1.myfritz.net:52605";
                  persistent-keepalive = 25;
                  allowed-ips = "192.168.69.0/24;0.0.0.0/0;fd9c:b5fd:70cf::/64;::/0;";
                  preshared-key = "$VPN_PSK_wg_Kaffeekanne";
                  preshared-key-flags = 0;
                };
                ipv4 = {
                  method = "manual";
                  address1 = "192.168.69.201/24";
                  dns = "192.168.69.1;";
                  dns-search = "fritz.box;";
                };
                ipv6 = {
                  method = "manual";
                  addr-gen-mode = "default";
                  address1 = "fd9c:b5fd:70cf::201/64";
                  dns = "fd9c:b5fd:70cf:0:d624:ddff:fe55:6a8c;";
                  dns-search = "fritz.box;";
                };
              };
            };
        };
        plugins = with pkgs; [networkmanager-openconnect];
      };
    };
    sops.secrets."networking/env" = {};
  };
}
