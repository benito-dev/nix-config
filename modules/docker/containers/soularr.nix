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
        image = "docker.io/mrusse08/soularr:latest";
        hostname = "soularr";
        user = "1000:993";
        extraOptions = [
          "--group-add=990"
          "--network=host"
        ];
        environment = {
          TZ = "Europe/Brussels";
          SCRIPT_INTERVAL = "60";
        };
        volumes = [
          "/dpool/data/soularr:/data"
          "/dpool/download/slskd/completed:/dpool/download/slskd/completed"
        ];
      };
    };
  };
}
