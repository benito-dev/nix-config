{ config, options, ... }:

{
  sops.secrets = {
    "sonarr/apikey" = { };
    "sonarr/username" = { };
    "sonarr/password" = { };
    "sonarr/ENV/apikey" = { };
    "radarr/apikey" = { };
    "radarr/username" = { };
    "radarr/password" = { };
    "radarr/ENV/apikey" = { };
  };

  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [ config.sops.secrets."sonarr/ENV/apikey".path ];
  };

  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [ config.sops.secrets."radarr/ENV/apikey".path ];
  };
}
