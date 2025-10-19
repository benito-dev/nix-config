{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [

    ./hardware-configuration.nix
    ../../modules/homeserver.nix
    ../common/homeserver
    ./zfs
    ./samba
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network

  networking = {

    defaultGateway = {
      address = "192.168.0.1";
      interface = "br0";
    };
    hostId = "37740ce0";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hostName = "homeserver";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 443 8096 ];
    };
    bridges."br0".interfaces = [
      "enp6s0"
      "enp7s0"
      "enp8s0"
      "enp9s0"
      "enp12s0"
    ];
    interfaces = {
      "br0".ipv4.addresses = [
        {
          address = "192.168.0.240";
          prefixLength = 24;
        }
      ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."192.168.0.240" = {
      forceSSL = true;
      sslCertificate = "/dpool/certs/myserver.local.pem";
      sslCertificateKey = "/dpool/certs/myserver.local-key.pem";
      locations."/".proxyPass = "http://localhost:8082";
      locations."/jellyfin".proxyPass = "http://localhost:8096";
      locations."/sonarr".proxyPass = "http://localhost:8989";
      locations."/radarr".proxyPass = "http://localhost:7878";
      locations."/prowlarr".proxyPass = "http://localhost:9696";
      locations."/qbittorrent/".proxyPass = "http://localhost:8080/";
      locations."/jellyseerr" = {
        proxyPass = "http://localhost:5055";
        extraConfig = '' 
              set $app 'jellyseerr';

              # Remove /jellyseerr path to pass to the app
              rewrite ^/jellyseerr/?(.*)$ /$1 break;

              # Redirect location headers
              proxy_redirect ^ /$app;
              proxy_redirect /setup /$app/setup;
              proxy_redirect /login /$app/login;

              # Sub filters to replace hardcoded paths
              proxy_set_header Accept-Encoding "";
              sub_filter_once off;
              sub_filter_types *;
              sub_filter 'href="/"' 'href="/$app"';
              sub_filter 'href="/login"' 'href="/$app/login"';
              sub_filter 'href:"/"' 'href:"/$app"';
              sub_filter '\/_next' '\/$app\/_next';
              sub_filter '/_next' '/$app/_next';
              sub_filter '/api/v1' '/$app/api/v1';
              sub_filter '/login/plex/loading' '/$app/login/plex/loading';
              sub_filter '/images/' '/$app/images/';
              sub_filter '/imageproxy/' '/$app/imageproxy/';
              sub_filter '/avatarproxy/' '/$app/avatarproxy/';
              sub_filter '/android-' '/$app/android-';
              sub_filter '/apple-' '/$app/apple-';
              sub_filter '/favicon' '/$app/favicon';
              sub_filter '/logo_' '/$app/logo_';
              sub_filter '/site.webmanifest' '/$app/site.webmanifest';
        '';
      };
    };
  };
  system.stateVersion = "25.05";

}
