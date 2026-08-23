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

  options.extraServices.podman."nexusm".enable = mkEnableOption "enable Nexusm";

  config = mkIf cfg."nexusm".enable {
    virtualisation.oci-containers.containers = {
      "nexusm" = {
        image = "docker.io/dockernexusm/nexusm:latest";
        hostname = "Nexusm";
        user = "1000:989";
        ports = [
          "8182:8182"
          "8183:8183"
        ];
        environment = {
          TZ = "Europe/Brussels";
          SCRIPT_INTERVAL = "60";
        };
        volumes = [
          #"/dpool/data/nexusm:/app"
          #"/dpool/download/slskd/downloads:"
        ];
      };
    };
  };
}
