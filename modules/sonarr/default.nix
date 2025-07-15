{ config, options, lib, pkgs, ... }:

let

  cfg = config.services.sonarr;

in {
  options.services.sonarr = {
    init = {
      enable = lib.mkEnableOption "Initializing Sonarr Authentication";

      apikey = lib.mkOption {
        description =
          "Sonarr api key, can be initialized via services.sonarr.environmentFiles, defaults to sops secret";
        type = lib.types.str;
        default = "cat ${config.sops.secrets."sonarr/apikey".path}";
      };

      username = lib.mkOption {
        description = "Sonarr user, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."sonarr/username".path})";
      };

      password = lib.mkOption {
        description = "Sonarr password, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."sonarr/password".path})";
      };

      method = lib.mkOption {
        description = "Authentication method, none basic external forms";
        type = lib.types.str;
        default = "forms";
      };

      required = lib.mkOption {
        description =
          "Authentication required for, enabled disabledForLocalAdresses";
        type = lib.types.str;
        default = "disabledForLocalAddresses";
      };
      rootPath = lib.mkOption {
        description = "Path to root path";
        type = lib.types.path;
        default = "/mnt/data/media/tvshows";
      };
      torrent.enable = lib.mkEnableOption "Initializing qBitorrent";
    };
  };

  config = lib.mkIf cfg.init.enable {
    systemd.services.initSonarr = {
      description = "Initialize Sonarr";
      after = [ "sonarr.service" ];
      wants = [ "sonarr.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
        #will update along the way when the need arises
        #settings.server.port for port option
        # ugly expansion within data portion of api call, should use jq ?
        ExecStart = pkgs.writeShellScript "Initialize Sonarr" ''
          ${pkgs.curl}/bin/curl -X 'PUT' 'http://localhost:8989/api/v3/config/host' \
            -H "X-Api-Key: $(${cfg.init.apikey})" \
            -H "Host: localhost:8989" \
            -H "Content-Type: application/json" \
            -d  '{
              "bindAddress": "*",
              "port": 8989,
              "sslPort": 9898,
              "enableSsl": false,
              "launchBrowser": true,
              "authenticationMethod": "'"${cfg.init.method}"'",
              "authenticationRequired": "'"${cfg.init.required}"'",
              "analyticsEnabled": false,
              "username": "'"${cfg.init.username}"'",
              "password": "'"${cfg.init.password}"'",
              "passwordConfirmation": "'"${cfg.init.password}"'",
              "logLevel": "debug",
              "logSizeLimit": 1,
              "consoleLogLevel": "",
              "branch": "main",
              "apiKey": "'"${cfg.init.apikey}"'",
              "sslCertPath": "",
              "sslCertPassword": "",
              "urlBase": "",
              "instanceName": "Sonarr",
              "applicationUrl": "",
              "updateAutomatically": false,
              "updateMechanism": "builtIn",
              "updateScriptPath": "",
              "proxyEnabled": false,
              "proxyType": "http",
              "proxyHostname": "",
              "proxyPort": 8080,
              "proxyUsername": "",
              "proxyPassword": "",
              "proxyBypassFilter": "",
              "proxyBypassLocalAddresses": true,
              "certificateValidation": "enabled",
              "backupFolder": "Backups",
              "backupInterval": 7,
              "backupRetention": 28,
              "trustCgnatIpAddresses": false,
              "id": 1
            }'   

          ${pkgs.curl}/bin/curl -X POST http://localhost:8989/api/v3/rootFolder \
            -H "X-Api-Key:$(cat ${cfg.init.apikey})" \
            -H "Content-Type: application/json" \
            -d '{"path":"'"${cfg.init.rootPath}"'"}'

          ${lib.optionalString cfg.init.torrent.enable ''
            ${pkgs.curl}/bin/curl -X POST http://localhost:8989/api/v3/downloadclient \
              -H "X-Api-Key:$(cat ${cfg.init.apikey})" \
              -H "Content-Type: application/json" \
              -d '{
                "enable": true,
                "name": "qBittorrent",
                "protocol": "torrent",
                "implementation": "QBittorrent",
                "configContract": "QBittorrentSettings",
                "fields": [
                  { "name": "host", "value": "localhost" },
                  { "name": "port", "value": 8080 },
                  { "name": "useSsl", "value": false },
                  { "name": "urlBase", "value": "" },
                  { "name": "username", "value": "'"${config.services.qbittorrent.username}"'"},
                  { "name": "password", "value": "'"${config.services.qbittorrent.password}"'"},
                  { "name": "category", "value": "sonarr" },
                  { "name": "recentTvPriority", "value": 1 },
                  { "name": "olderTvPriority", "value": 1 },
                  { "name": "addPaused", "value": false }],
                "priority": 1,
                "removeCompletedDownloads": true,
                "removeFailedDownloads": true }'
          ''}
        '';

      };
    };
  };
}

