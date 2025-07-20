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

  extraServices.podman.enable = true;
  virtualisation.oci-containers = {
    containers = {
      "flaresolverr" = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        environment = {
          LOG_LEVEL = "info";
          LOG_HTML = "false";
          CAPTCHA_SOLVER = "none";
          TZ = "Europe/Brussels";
        };
        ports = [ "8191:8191" ];
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8191 ];

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
    init.enable = true;
  };
}
