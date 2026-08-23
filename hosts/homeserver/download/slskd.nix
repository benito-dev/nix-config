{
  config,
  options,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "slskd" = { };
    "soulseek/apikey" = { };
  };
  services.slskd = {
    enable = true;
    user = "slskd";
    group = "media";
    domain = null;
    environmentFile = config.sops.secrets."slskd".path;
    settings = {
      web.authentication.apiKeys."api-homepage" = {
        key = config.sops.secrets."soulseek/apikey".path;
      };
      shares.directories = [ "/dpool/media/music" ];
      directories.downloads = "/dpool/download/slskd/completed/";
      directories.incomplete = "/dpool/download/slskd/incomplete/";
      remote_file_management = "true";
      transfers.upload = {
        slots = "20";
        speed_limit = "1000";
      };
    };
  };
  systemd.services = {
    slskd = {
      serviceConfig = {
        UMask = "007";
      };
    };
  };
}
