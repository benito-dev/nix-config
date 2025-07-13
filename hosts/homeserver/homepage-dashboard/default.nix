{ config, pkgs, ... }:

{
  imports = [ ./services.nix ./settings.nix ./widget.nix ];

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "*";
    environmentFile = "${config.sops.secrets."homepage-dashboard".path}";
  };
}

