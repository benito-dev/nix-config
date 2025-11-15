{ config, pkgs, ... }:

{
  imports = [
    ./services.nix
    ./settings.nix
    # ./widget.nix
  ];

  sops.secrets = {
    "homepage-dashboard" = { };
  };

  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "*";
    environmentFile = "${config.sops.secrets."homepage-dashboard".path}";
    #package = pkgs-stable.homepage-dashboard;
  };
  services.glances = {
    enable = true;
    extraArgs = [
      "--webserver"
    ];
  };
}
