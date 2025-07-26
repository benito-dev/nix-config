{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.extraServices.podman;
in

{
  options.extraServices.podman."flaresolverr".enable = mkEnableOption "enable flaresolverr";

  config = mkIf cfg.flaresolverr.enable {
    virtualisation.oci-containers.containers = {
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
}
