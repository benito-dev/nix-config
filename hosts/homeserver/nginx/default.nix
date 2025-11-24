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

        "/".proxyPass = "http://localhost:8082";

        "/adguard/".proxyPass = "http://localhost:3000/";

        "/jellyfin".proxyPass = "http://localhost:8096";

        "/sonarr".proxyPass = "http://localhost:8989";

        "/radarr".proxyPass = "http://localhost:7878";

        "/prowlarr".proxyPass = "http://localhost:9696";

        "/qbittorrent/".proxyPass = "http://localhost:8080/";

        "/jellyseerr/" = {
          proxyPass = "http://localhost:5055/";
          extraConfig = ''
            set $app 'jellyseerr';
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
    virtualHosts."bilbedon.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {

        "/".proxyPass = "http://localhost:9091";

        "/homepage/" = {
          proxyPass = "http://localhost:8082/";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-URI $request_uri;
            proxy_set_header X-Forwarded-Ssl on;
            proxy_set_header X-Forwarded-For $remote_addr;

            auth_request /internal/authelia/authz;

            client_body_buffer_size 128k;
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; ## Timeout if the real server is dead.
            proxy_redirect  http://  $scheme://;
            proxy_http_version 1.1;
            proxy_cache_bypass $cookie_session;
            proxy_no_cache $cookie_session;
            proxy_buffers 64 256k;

            ## Trusted Proxies Configuration
            set_real_ip_from 192.168.0.240;
            real_ip_header X-Forwarded-For;
            real_ip_recursive on;

            ## Advanced Proxy Configuration
            send_timeout 5m;
            proxy_read_timeout 360;
            proxy_send_timeout 360;
            proxy_connect_timeout 360;

            ## Save the upstream metadata response headers from Authelia to variables.
            auth_request_set $user $upstream_http_remote_user;
            auth_request_set $groups $upstream_http_remote_groups;
            auth_request_set $name $upstream_http_remote_name;
            auth_request_set $email $upstream_http_remote_email;

            ## Inject the metadata response headers from the variables into the request made to the backend.
            proxy_set_header Remote-User $user;
            proxy_set_header Remote-Groups $groups;
            proxy_set_header Remote-Email $email;
            proxy_set_header Remote-Name $name;

            ## Modern Method: Set the $redirection_url to the Location header of the response to the Authz endpoint.
            auth_request_set $redirection_url $upstream_http_location;

          '';
        };

        "/internal/authelia/authz" = {
          proxyPass = "http://localhost:9091/authelia/api/authz/auth-request";
          extraConfig = ''
            ## Headers
            ## The headers starting with X-* are required.
            internal;

            proxy_set_header X-Original-Method $request_method;
            proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header Content-Length "";
            proxy_set_header Connection "";

            ## Basic Proxy Configuration
            proxy_pass_request_body off;
            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; # Timeout if the real server is dead
            proxy_redirect http:// $scheme://;
            proxy_http_version 1.1;
            proxy_cache_bypass $cookie_session;
            proxy_no_cache $cookie_session;
            proxy_buffers 4 32k;
            client_body_buffer_size 128k;

            ## Advanced Proxy Configuration
            send_timeout 5m;
            proxy_read_timeout 240;
            proxy_send_timeout 240;
            proxy_connect_timeout 240;'';
        };

        "/jellyfin".proxyPass = "http://localhost:8096";

        "/sonarr".proxyPass = "http://localhost:8989";

        "/radarr".proxyPass = "http://localhost:7878";

        "/prowlarr".proxyPass = "http://localhost:9696";

        "/qbittorrent/".proxyPass = "http://localhost:8080/";

        "/jellyseerr/" = {
          proxyPass = "http://localhost:5055/";
          extraConfig = ''
            set $app 'jellyseerr';
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
  };
}
