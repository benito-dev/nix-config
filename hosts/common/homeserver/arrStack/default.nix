{
  config,
  options,
  pkgs,
  ...
}:

{
  imports = [ ./recyclarr.nix ];
  sops.secrets = {
    "sonarr/apikey" = { };
    "sonarr/username" = { };
    "sonarr/password" = { };
    "sonarr/ENV/apikey" = { };
    "radarr/apikey" = { };
    "radarr/username" = { };
    "radarr/password" = { };
    "radarr/ENV/apikey" = { };
    "prowlarr/ENV/apikey" = { };
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

  services.prowlarr = {
    enable = true;
    openFirewall = true;
    #init.enable = true;
    environmentFiles = [ config.sops.secrets."prowlarr/ENV/apikey".path ];
  };

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    init.enable = true;
  };
}
