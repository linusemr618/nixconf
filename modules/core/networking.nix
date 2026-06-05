{
  flake.modules.nixos.core = {
    config,
    lib,
    pkgs,
    ...
  }: let
    wifiNetworks = {
      "AP23_Main" = ["AP23-Main" "sae"];
      "ELI" = ["ELI" "sae"];
      "GRUENE" = ["GRUENE" "wpa-psk"];
      "Kaffeekanne" = ["Kaffeekanne" "sae"];
      "Pixel_8_Pro" = ["Pixel 8 Pro" "sae"];
      "VDSt_WLAN" = ["VDSt-WLAN" "sae"];
      "Vodafone_2085" = ["Vodafone-2085" "sae"];
      "WLAN_770356_EXT2_4G" = ["WLAN-770356_EXT2.4G" "sae"];
    };
    mkWifiProfile = id: values: let
      ssid = builtins.elemAt values 0;
      keyMgmt = builtins.elemAt values 1;
    in {
      connection = {
        id = ssid;
        type = "wifi";
      };
      wifi = {
        mode = "infrastructure";
        ssid = ssid;
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = keyMgmt;
        psk = "$WIFI_${id}";
      };
      ipv4.method = "auto";
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
    };
  in {
    networking = {
      hostName = "${config.host.name}";
      networkmanager = {
        enable = true;
        ensureProfiles = {
          environmentFiles = [config.sops.secrets."networking/env".path];
          profiles =
            lib.mapAttrs mkWifiProfile wifiNetworks
            // {
              Kaffeekanne_P = {
                connection = {
                  id = "Kaffeekanne_P";
                  type = "wifi";
                  autoconnect = false;
                };
                wifi.ssid = "Kaffeekanne_P";
                wifi-security = {
                  key-mgmt = "sae";
                  psk = "$WIFI_Kaffeekanne_P";
                };
                ipv4.method = "auto";
                ipv6 = {
                  addr-gen-mode = "default";
                  method = "auto";
                };
              };

              eduroam = {
                connection = {
                  id = "eduroam";
                  type = "wifi";
                };
                wifi = {
                  mode = "infrastructure";
                  ssid = "eduroam";
                };
                wifi-security = {
                  auth-alg = "open";
                  key-mgmt = "wpa-eap";
                };
                "802-1x" = {
                  eap = "pwd";
                  identity = "$WIFI_eduroam_IDENTITY";
                  password = "$WIFI_eduroam_PASSWORD";
                };
                ipv4.method = "auto";
                ipv6 = {
                  addr-gen-mode = "default";
                  method = "auto";
                };
              };

              WG_Kaffeekanne = {
                connection = {
                  id = "WG_Kaffeekanne";
                  type = "wireguard";
                  autoconnect = false;
                  interface-name = "WG_Kaffeekanne";
                  permissions = "user:${config.user.name}:;";
                };
                wireguard = {
                  listen-port = 51820;
                  private-key = "$VPN_WG_Kaffeekanne_PRIVATE_KEY";
                };
                "wireguard-peer.JW/FlZp2O05ragkAoFD/h6TXaw8h1hFhSI0USUEWSkQ=" = {
                  endpoint = "$VPN_WG_Kaffeekanne_ENDPOINT";
                  persistent-keepalive = 25;
                  allowed-ips = "192.168.69.0/24;0.0.0.0/0;fd9c:b5fd:70cf::/64;::/0;";
                  preshared-key = "$VPN_WG_Kaffeekanne_PRESHARED_KEY";
                  preshared-key-flags = 0;
                };
                ipv4 = {
                  address1 = "192.168.69.201/24";
                  dns = "192.168.69.1;";
                  dns-search = "fritz.box;";
                  method = "manual";
                };
                ipv6 = {
                  addr-gen-mode = "default";
                  address1 = "fd9c:b5fd:70cf::201/64";
                  dns = "fd9c:b5fd:70cf:0:d624:ddff:fe55:6a8c;";
                  dns-search = "fritz.box;";
                  method = "manual";
                };
              };

              DE_348 = {
                connection = {
                  id = "DE_348";
                  type = "wireguard";
                  autoconnect = "false";
                  interface-name = "DE_348";
                  permissions = "user:${config.user.name}:;";
                };
                wireguard = {
                  listen-port = 51820;
                  private-key = "$VPN_DE_348_PRIVATE_KEY";
                };
                "wireguard-peer.hOoBBy//7mddXPz1SybzWB3zK95SQCcPyI/DmxfULXk=" = {
                  endpoint = "149.88.102.97:51820";
                  persistent-keepalive = 25;
                  allowed-ips = "0.0.0.0/0;::/0;";
                };
                ipv4 = {
                  address1 = "10.2.0.2/32";
                  dns = "10.2.0.1;";
                  dns-search = "~;";
                  method = "manual";
                };
                ipv6 = {
                  addr-gen-mode = "default";
                  address1 = "2a07:b944::2:2/128";
                  dns = "2a07:b944::2:1;";
                  dns-search = "~;";
                  method = "manual";
                };
              };

              RWTH = {
                connection = {
                  id = "RWTH";
                  type = "vpn";
                  autoconnect = false;
                  permissions = "user:${config.user.name}:;";
                };
                vpn = {
                  authtype = "password";
                  autoconnect-flags = 0;
                  certsigs-flags = 0;
                  cookie-flags = 2;
                  disable_udp = "no";
                  enable_csd_trojan = "no";
                  gateway = "vpn.rwth-aachen.de";
                  gateway-flags = 2;
                  gwcert-flags = 2;
                  lasthost-flags = 0;
                  pem_passphrase_fsid = "no";
                  prevent_invalid_cert = "no";
                  protocol = "anyconnect";
                  resolve-flags = "2";
                  stoken_source = "disabled";
                  useragent = "AnyConnect";
                  xmlconfig-flags = 0;
                  service-type = "org.freedesktop.NetworkManager.openconnect";
                };
                vpn-secrets = {
                  "form:main:group_list" = "RWTH-VPN (Full Tunnel)";
                  "form:main:username" = "$VPN_RWTH_USERNAME";
                  lasthost = "vpn.rwth-aachen.de (SSLVPN)";
                  save_passwords = "yes";
                  xmlconfig = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxBbnlDb25uZWN0UHJvZmlsZSB4bWxucz0iaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvZW5jb2RpbmcvIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL2VuY29kaW5nLyBBbnlDb25uZWN0UHJvZmlsZS54c2QiPg0KCTxDbGllbnRJbml0aWFsaXphdGlvbj4NCgkJPElQUHJvdG9jb2xTdXBwb3J0PklQdjYsSVB2NDwvSVBQcm90b2NvbFN1cHBvcnQ+DQoJPC9DbGllbnRJbml0aWFsaXphdGlvbj4NCgk8U2VydmVyTGlzdD4NCgkJPEhvc3RFbnRyeT4NCgkJCTxIb3N0TmFtZT52cG4ucnd0aC1hYWNoZW4uZGUgKElQc2VjKTwvSG9zdE5hbWU+DQoJCQk8SG9zdEFkZHJlc3M+dnBuLnJ3dGgtYWFjaGVuLmRlPC9Ib3N0QWRkcmVzcz4NCgkJCTxQcmltYXJ5UHJvdG9jb2w+SVBzZWM8L1ByaW1hcnlQcm90b2NvbD4NCgkJPC9Ib3N0RW50cnk+DQoJCTxIb3N0RW50cnk+DQoJCQk8SG9zdE5hbWU+dnBuLnJ3dGgtYWFjaGVuLmRlIChTU0xWUE4pPC9Ib3N0TmFtZT4NCgkJCTxIb3N0QWRkcmVzcz52cG4ucnd0aC1hYWNoZW4uZGU8L0hvc3RBZGRyZXNzPg0KCQk8L0hvc3RFbnRyeT4NCgk8L1NlcnZlckxpc3Q+DQo8L0FueUNvbm5lY3RQcm9maWxlPg0K";
                };
                ipv4.method = "auto";
                ipv6 = {
                  addr-gen-mode = "default";
                  method = "auto";
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
