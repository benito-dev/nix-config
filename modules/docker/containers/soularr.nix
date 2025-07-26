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

  options.extraServices.podman.soularr.enable = mkEnableOption "enable soularr";

  config = mkIf cfg.soularr.enable {
    virtualisation.oci-containers.containers = {
      "soularr" = {
        image = "mrusse08/soularr:latest";
        hostname = "soularr";
        user = "1000:1000";
        extraOptions = [
          "--group-add=990"
          "--group-add=993"
        ];
        environment = {
          TZ = "Europe/Brussels";
          SCRIPT_INTERVAL = "60";
        };
        volumes = [
          "/dpool/data/soularr:/data"
          "/dpool/download/slskd/downloads:/downloads"
        ];
      };
    };
  };
}
