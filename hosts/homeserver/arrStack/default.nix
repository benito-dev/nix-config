{ config, options,  ... }:

{
  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [
      config.sops.secrets."sonarr/ENV/apikey".path
    ];
  };
  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };
}
