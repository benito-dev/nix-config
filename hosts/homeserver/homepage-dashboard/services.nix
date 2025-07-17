# For configuration options and examples, please see:
# https://gethomepage.dev/latest/configs/services
{ config, ... }: {
  services.homepage-dashboard.services = [{
    "Media" = [
      {
        "Jellyseerr" = {
          href =
            "http://192.168.0.240:${toString config.services.jellyseerr.port}";
          icon = "jellyseerr";
          widget = {
            type = "jellyseerr";
            url = "http://192.168.0.240:${
                toString config.services.jellyseerr.port
              }";
            key =
              "MTc1MjY5NjgxNjU5MmVjNmQwZDY5LTdhMDMtNGE5Yy05NWMzLTMyMjFjN2FhMzc4NQ==";
          };
        };
      }
      {
        "Sonarr" = {
          href = "http://192.168.0.240:${
              toString config.services.sonarr.settings.server.port
            }";
          icon = "sonarr.png";
          widget = {
            type = "sonarr";
            url = "http://192.168.0.240:${
                toString config.services.sonarr.settings.server.port
              }";
            key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
            enableQueue = true;
          };
        };
      }
      {
        "Radarr" = {
          href = "http://192.168.0.240:${
              toString config.services.radarr.settings.server.port
            }";
          icon = "radarr.png";
          widget = {
            type = "radarr";
            url = "http://192.168.0.240:${
                toString config.services.radarr.settings.server.port
              }";
            key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
            enableQueue = true;
          };
        };
      }
      {
        "Prowlarr" = {
          href = "http://192.168.0.240:${
              toString config.services.prowlarr.settings.server.port
            }";
          icon = "prowlarr";
          widget = {
            type = "prowlarr";
            url = "http://192.168.0.240:${
                toString config.services.prowlarr.settings.server.port
              }";
            key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
          };
        };
      }
      {
        "qBittorrent" = {
          href =
            "http://192.168.0.240:${toString config.services.qbittorrent.port}";
          icon = "qbittorrent.png";
          widget = {
            type = "qbittorrent";
            url = "http://192.168.0.240:${
                toString config.services.qbittorrent.port
              }";
            enableLeechProgress = true;
          };
        };
      }
      {
        "Jellyfin" = {
          href = "http://192.168.0.240:${
              toString
              config.services.declarative-jellyfin.network.internalHttpPort
            }";
          icon = "jellyfin";
          widget = {
            type = "jellyfin";
            url = "http://192.168.0.240:${
                toString
                config.services.declarative-jellyfin.network.internalHttpPort
              }";
            key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
            enableBlocks = true;
          };
        };
      }
    ];
  }];
}
