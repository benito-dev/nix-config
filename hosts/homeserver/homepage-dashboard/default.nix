{ config, pkgs, ... }:

{
  imports = [ ./services.nix ./settings.nix ./widget.nix ];

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "*";
    environmentFiles =  "${config.sops.secrets."homepage-dashboard/sonarr_apikey".path}" ;
  };
}

