{
  config,
  options,
  pkgs,
  ...
}:

{
  sops.secrets = {
    "lidarr/ENV/apikey" = { };
    "lidarr/apikey" = { };
    "lidarr/username" = { };
    "lidarr/password" = { };
  };
  services.lidarr = {
    enable = true;
    group = "media";
    environmentFiles = [ config.sops.secrets."lidarr/ENV/apikey".path ];
    init.enable = true;
  };
  extraServices.podman."soularr".enable = true;
}
