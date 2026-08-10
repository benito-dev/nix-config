{ config, ... }:
{

  security.acme = {
    acceptTerms = true;
    defaults.email = "benoit.blervaque@gmail.com";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."192.168.0.240" = {
      forceSSL = true;
      enableACME = true;
      locations = {

        "/" = {
          proxyPass = "http://localhost:8082/";
        };

        "/adguard/".proxyPass = "http://localhost:3000/";

        "/jellyfin".proxyPass = "http://localhost:8096";

        "/sonarr".proxyPass = "http://localhost:8989";

        "/radarr".proxyPass = "http://localhost:7878";

        "/prowlarr".proxyPass = "http://localhost:9696";

        "/qbittorrent/".proxyPass = "http://localhost:8080/";

        "/seerr/" = {
          proxyPass = "http://localhost:5055/";
          extraConfig = ''
            set $app 'seerr';
            proxy_headers_hash_max_size 1024;
            proxy_headers_hash_bucket_size 128;
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

    virtualHosts."bil-tril.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8085/";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection 'upgrade';
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        '';
      };
      extraConfig = ''
        client_max_body_size 0;
      '';
    };

    virtualHosts."biljel.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8096";     
      };
    };
    virtualHosts."94.110.0.87" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {

      };
    };
  };
}
