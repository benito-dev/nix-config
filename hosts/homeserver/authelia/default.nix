{ config, ... }:
{
  sops.secrets = {
    "authelia/jwtSecret" = {
      owner = "authelia-main";
      group = "authelia-main";
    };
    "authelia/storageEncryptionKeyFile" = {
      owner = "authelia-main";
      group = "authelia-main";
    };
  };

  services.authelia.instances = {
    main = {
      enable = true;
      secrets.jwtSecretFile = config.sops.secrets."authelia/jwtSecret".path;
      secrets.storageEncryptionKeyFile = config.sops.secrets."authelia/storageEncryptionKeyFile".path;

      settings = {

        server = {
          address = "tcp://localhost:9091/";
          endpoints.authz.auth-request.implementation = "AuthRequest";
        };

        log = {
          level = "debug";
          format = "text";
        };

        authentication_backend = {
          file = {
            path = "/var/lib/authelia-main/users_database.yml";
          };
        };
        access_control = {
          default_policy = "deny";
          rules = [
            {
              domain = [ "bilhomelab.duckdns.org" ];
              policy = "one_factor";
            }

          ];
        };

        session = {
          name = "authelia_session";
          expiration = "12h";
          inactivity = "45m";
          remember_me = "1M";
          cookies = [
            {
              domain = "bilhomelab.duckdns.org";
              authelia_url = "https://auth.bilhomelab.duckdns.org";
              default_redirection_url = "https://bilhomelab.duckdns.org";
            }
          ];
        };

        regulation = {
          max_retries = 3;
          find_time = "5m";
          ban_time = "15m";
        };

        storage = {
          local = {
            path = "/var/lib/authelia-main/db.sqlite3";
          };
        };

        notifier = {
          disable_startup_check = false;
          filesystem = {
            filename = "/var/lib/authelia-main/notification.txt";
          };
        };
      };
    };
  };
}
