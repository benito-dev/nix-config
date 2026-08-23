{ config, ... }:
{

  security.acme = {
    acceptTerms = true;
    defaults.email = "benoit.blervaque@gmail.com";
    certs."bilhome.duckdns.org" = {
      dnsProvider = "duckdns";
      environmentFile = "/var/lib/acme/duckdns.env";
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."bilhome.duckdns.org" = {
      forceSSL = true;
      useACMEHost = "bilhome.duckdns.org";
      locations = {
        "/" = {
          proxyPass = "http://localhost:8082/";
        };
      };
    };
    virtualHosts."jelly.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8096/";
        };
      };
    };
    virtualHosts."seerr.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:5055/";
        };
      };
    };
    virtualHosts."sonarr.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8989/";
        };
      };
    };
    virtualHosts."radarr.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:7878/";
        };
      };
    };
    virtualHosts."prowlarr.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:9696/";
        };
      };
    };
    virtualHosts."qbit.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8080/";
        };
      };
    };
    virtualHosts."slsk.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:5030/";
        };
      };
    };
    virtualHosts."lidarr.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8686/";
        };
      };
    };
    virtualHosts."adguard.bilhome.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:3000";
        };
      };
    };
    virtualHosts."auth.bilhomelab.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:9091/";
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
    virtualHosts."bilhomelab.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8082/";
        extraConfig = ''

          set $target_url $scheme://$http_host$request_uri;

          # Forward authentication requests to Authelia's internal endpoint
          auth_request /authelia;

          # Copy headers returned by Authelia to the protected upstream
          auth_request_set $user $upstream_http_remote_user;
          auth_request_set $groups $upstream_http_remote_groups;
          auth_request_set $name $upstream_http_remote_name;
          auth_request_set $email $upstream_http_remote_email;

          proxy_set_header Remote-User $user;
          proxy_set_header Remote-Groups $groups;
          proxy_set_header Remote-Name $name;
          proxy_set_header Remote-Email $email;

          # Handle redirect to Authelia login portal when unauthorized (401)
          error_page 401 =302 https://auth.bilhomelab.duckdns.org;
        '';
      };
      locations."/authelia" = {
        proxyPass = "http://127.0.0.1:9091/api/authz/auth-request";
        extraConfig = ''

          proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
          proxy_set_header X-Original-Method $request_method;

          proxy_set_header Content-Length "";
          proxy_pass_request_body off;

          # These are required for Authelia to correctly evaluate the request
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Method $request_method;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
          proxy_set_header X-Forwarded-Uri $request_uri;
        '';
      };
    };
    virtualHosts."jelly.bilhomelab.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8096/";
        };
      };
    };
    virtualHosts."seerr.bilhomelab.duckdns.org" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:5055/";
        };
      };
    };
  };
}
