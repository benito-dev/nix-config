# For configuration options and examples, please see:
# https://gethomepage.dev/latest/configs/services
{config, ... }:

{
  services.homepage-dashboard.services = [{
    "Media" = [
      {
        "Sonarr" = {
          href = "http://localhost:${toString config.services.sonarr.settings.server.port}";
          icon = "sonarr.png";
          widget = {
            type = "sonarr";
            url = "http://localhost:${toString config.services.sonarr.settings.server.port}";
            key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
            enableQueue = true;
          };
        };
      }
      {
        "Radarr" = {
          href = "http://192.168.0.240:7878";
          icon = "radarr.png";
          widget = {
            type = "radarr";
            url = "http://192.168.0.240:7878";
            key = "a2b476e77f414908b8bb51d4f6100f0e";
            enableQueue = true;
          };
        };
      }
      {
        "qBittorrent" = {
          href = "http://192.168.0.240:8080";
          icon = "qbittorrent.png";
          widget = {
            type = "qbittorrent";
            url = "http://192.168.0.240:8080";
            enableLeechProgress = true;
          };
        };
      }
    ];
  }];
}