# For configuration options and examples, please see:
# https://gethomepage.dev/latest/configs/services
{ config, ... }:
let
  privateDomain = "bilhome.duckdns.org";
  publicDomain = "bilhomelab.duckdns.org";
in
{
  services.homepage-dashboard.services = [
    {
      "Monitoring" = [
        {
          "cpu" = {
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "cpu";
              chart = false;
            };
          };
        }

        {
          "Memory" = {
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "memory";
              chart = false;
            };
          };
        }
        {
          "Gpu" = {
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "gpu:amd0";
              chart = false;
            };
          };
        }
        {
          "network" = {
            refreshInterval = 500;
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "network:br0";
              chart = false;
            };
          };

        }
        {
          "Dpool" = {
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "fs:/dpool";
              chart = false;
            };
          };
        }

        {
          "/" = {
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "fs:/";
              chart = false;
            };
          };
        }
      ];
    }
    {
      "Media" = [
        {
          "qBittorrent" = {
            href = "http://qbit.${privateDomain}";
            icon = "qbittorrent.png";
            widget = {
              type = "qbittorrent";
              url = "http://localhost:${toString config.services.qbittorrent.webuiPort}";
              enableLeechProgress = true;
            };
          };
        }
        {
          "Jellyfin" = {
            href = "http://jelly.${publicDomain}";
            icon = "jellyfin";
            widget = {
              type = "jellyfin";
              url = "http://localhost:8096/";
              key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
              enableBlocks = true;
            };
          };
        }
        {
          "Seerr" = {
            href = "https://seerr.${publicDomain}";
            icon = "jellyseerr";
            widget = {
              type = "jellyseerr";
              url = "http://localhost:${toString config.services.seerr.port}";
              key = "{{HOMEPAGE_VAR_SEERR_API_KEY}}";
            };
          };
        }
        {
          "Sonarr" = {
            href = "https://sonarr.${privateDomain}";
            icon = "sonarr.png";
            widget = {
              type = "sonarr";
              url = "http://localhost:8989";
              key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
              #enableQueue = true;
            };
          };
        }
        {
          "Radarr" = {
            href = "https://radarr.${privateDomain}";
            icon = "radarr.png";
            widget = {
              type = "radarr";
              url = "http://localhost:${toString config.services.radarr.settings.server.port}";
              key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
              #enableQueue = true;
            };
          };
        }
        {
          "Prowlarr" = {
            href = "http://prowlarr.${privateDomain}";
            icon = "prowlarr";
            widget = {
              type = "prowlarr";
              url = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
              key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
            };
          };
        }

      ];
    }
    {
      "Tools" = [
        {
          "Trilium" = {
            href = "http://tril.${publicDomain}";
            icon = "trilium";
            widget = {
              type = "trilium";
              url = "http://localhost:8085";
              key = "{{HOMEPAGE_VAR_TRILIUM_API_KEY}}";
            };
          };
        }
      ];
    }
    {
      "Music" = [
        {
          "Slskd" = {
            href = "http://slsk.${privateDomain}";
            icon = "slskd";
            widget = {
              type = "slskd";
              url = "http://127.0.0.1:5030";
              key = config.sops.secrets."soulseek/apikey".path;
            };
          };
        }
        {
          "Lidarr" = {
            href = "http://lidarr.${privateDomain}";
            icon = "lidarr";
            widget = {
              type = "lidarr";
              url = "http://localhost:8686";
              key = "{{HOMEPAGE_VAR_LIDARR_API_KEY}}";
            };
          };
        }
      ];

    }
    {
      "Network" = [
        {
          "Cockpit" = {
            href = "http://192.168.0.240:9090";
            icon = "cockpit";
          };
        }
        {
          "Adguard" = {
            href = "http://adguard.${privateDomain}";
            icon = "adguard-home";
            widget = {
              type = "adguard";
              url = "http://localhost:3000";
              username = "benito";
              password = "test";
              fields = [
                "queries"
                "blocked"
                "filtered"
                "latency"
              ];
            };
          };
        }
      ];
    }
  ];
}
