# For configuration options and examples, please see:
# https://gethomepage.dev/latest/configs/services
{ config, ... }:
{
  services.homepage-dashboard.services = [
    {
      "AMonitoring" = [
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
          "network" = {
            refreshInterval = 500;
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "network:br0";

            };
          };
        }
        {
          "process" = {
            widget = {
              type = "glances";
              version = 4;
              url = "http://localhost:61208";
              metric = "process";
            };
            refreshInterval = 500;
          };
        }
      ];
    }
    {
      "Media" = [
        {
          "Jellyseerr" = {
            href = "http://192.168.0.240/jellyseerr";
            icon = "jellyseerr";
            widget = {
              type = "jellyseerr";
              url = "http://localhost:${toString config.services.jellyseerr.port}";
              key = "MTc2MjU0NjQ5ODk0Njk4MThmNmE2LTU2ZTktNDlmZS1hMTM1LWViNmIzZmUwNTI1Yg==";
            };
          };
        }
        {
          "Sonarr" = {
            href = "http://192.168.0.240/sonarr";
            icon = "sonarr.png";
            widget = {
              type = "sonarr";
              url = "http://localhost:8989";
              key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
              enableQueue = true;
            };
          };
        }
        {
          "Radarr" = {
            href = "http://192.168.0.240/radarr";
            icon = "radarr.png";
            widget = {
              type = "radarr";
              url = "http://localhost:${toString config.services.radarr.settings.server.port}";
              key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
              enableQueue = true;
            };
          };
        }
        {
          "Prowlarr" = {
            href = "http://192.168.0.240/prowlarr";
            icon = "prowlarr";
            widget = {
              type = "prowlarr";
              url = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
              key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
            };
          };
        }
        {
          "qBittorrent" = {
            href = "http://192.168.0.240/qbittorrent";
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
            href = "http://192.168.0.240/jellyfin";
            icon = "jellyfin";
            widget = {
              type = "jellyfin";
              url = "http://localhost:8096/jellyfin";
              key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
              enableBlocks = true;
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
            href = "http://192.168.0.240/adguard";
            icon = "adguard-home";
            widget = {
              type = "adguard-home";
              url = "http://localhost:3000";
              user = "benito";
              password = "test";
            };
          };
        }
      ];
    }
  ];
}
