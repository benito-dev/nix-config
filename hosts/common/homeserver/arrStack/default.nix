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
    "prowlarr/apikey" = { };
    "prowlarr/username" = { };
    "prowlarr/password" = { };
    "prowlarr/ENV/apikey" = { };
    "lidarr/ENV/apikey" = { };
    "lidarr/apikey" = { };
    "lidarr/username" = { };
    "lidarr/password" = { };
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
    init.enable = true;
    environmentFiles = [ config.sops.secrets."prowlarr/ENV/apikey".path ];
  };
  extraServices.podman."flaresolverr".enable = true;
  networking.firewall.allowedTCPPorts = [ 8191 ];

  services.lidarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    environmentFiles = [ config.sops.secrets."lidarr/ENV/apikey".path ];
    init.enable = true;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    init.enable = true;
  };
}
