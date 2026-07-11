{inputs, ...}: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports = [inputs.zen-browser.homeModules.beta];
    programs.zen-browser = {
      enable = true;
      profiles.default = {
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            proton-pass
            proton-vpn
            ublock-origin
            video-downloadhelper
          ];
        };
        search = {
          force = true;
          default = "startpage";
          engines = {
            nixos-options = {
              name = "NixOS Options";
              urls = [{template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";}];
              definedAliases = ["@no"];
            };
            nixos-packages = {
              name = "NixOS Packages";
              urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
              definedAliases = ["@np"];
            };
            nixos-wiki = {
              name = "NixOS Wiki";
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
              definedAliases = ["@nw"];
            };
            startpage = {
              name = "Startpage";
              urls = [
                {
                  method = "POST";
                  template = "https://www.startpage.com/sp/search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }

                {
                  type = "application/x-suggestions+json";
                  template = "https://www.startpage.com/osuggestions?query={searchTerms}";
                }
              ];
              definedAliases = ["@sp"];
            };
          };
        };
        settings = {
          "browser.download.useDownloadDir" = false;
          "browser.ml.linkPreview.enabled" = true;
          "browser.ml.linkPreview.optin" = true;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = true;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = true;
          "browser.search.suggest.enabled" = true;
          "browser.translations.neverTranslateLanguages" = "de";
          "dom.security.https_only_mode" = true;
          "network.trr.mode" = 3;
          "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
          "privacy.history.custom" = false;
          "privacy.trackingprotection.allow_list.convenience.enabled" = true;
          "zen.tabs.show-newtab-vertical" = false;
          "zen.view.show-newtab-button-top" = false;

          "browser.contentblocking.category" = "strict";
          "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
          "network.lna.blocking" = true;
          "privacy.annotate_channels.strict_list.enabled" = true;
          "privacy.bounceTrackingProtection.mode" = 1;
          "privacy.fingerprintingProtection" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.trackingprotection.consentmanager.skip.pbmode.enabled" = false;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
        };
      };
    };
  };
}
