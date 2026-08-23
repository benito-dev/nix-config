{
  config,
  options,
  pkgs,
  ...
}:

{
  imports = [
    ./recyclarr.nix
    ./lidarr.nix
  ];
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

  };

  services.sonarr = {
    enable = true;
    group = "media";
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [ config.sops.secrets."sonarr/ENV/apikey".path ];
  };

  services.radarr = {
    enable = true;
    group = "media";
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [ config.sops.secrets."radarr/ENV/apikey".path ];
  };

  services.prowlarr = {
    enable = true;
    init.enable = true;
    environmentFiles = [ config.sops.secrets."prowlarr/ENV/apikey".path ];
  };
  extraServices.podman."flaresolverr".enable = true;

  networking.firewall.allowedTCPPorts = [ 8191 ];
  services.seerr = {
    enable = true;
    init.enable = false;
    openFirewall = true;
  };
}
