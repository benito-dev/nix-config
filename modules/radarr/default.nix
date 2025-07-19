{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.radarr;

in
{
  options.services.radarr = {
    init = {
      enable = lib.mkEnableOption "Initializing Radarr Authentication";

      apikey = lib.mkOption {
        description = "Radarr api key, can be initialized via services.sonarr.environmentFiles, defaults to sops secret";
        type = lib.types.str;
        default = "cat ${config.sops.secrets."radarr/apikey".path}";
      };

      username = lib.mkOption {
        description = "Radarr user, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."radarr/username".path})";
      };

      password = lib.mkOption {
        description = "Radarr password, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."radarr/password".path})";
      };

      method = lib.mkOption {
        description = "Authentication method, none basic external forms";
        type = lib.types.str;
        default = "forms";
      };

      required = lib.mkOption {
        description = "Authentication required for, enabled disabledForLocalAdresses";
        type = lib.types.str;
        default = "disabledForLocalAddresses";
      };
      rootPath = lib.mkOption {
        description = "Path to root path";
        type = lib.types.path;
        default = "/dpool/media/movies";
      };
      torrent.enable = lib.mkEnableOption "Initializing qBitorrent";
    };
  };

  config = lib.mkIf cfg.init.enable {
    systemd.services.initRadarr = {
      description = "Initialize Radarr";
      after = [ "radarr.service" ];
      wants = [ "radarr.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        #will update along the way when the need arises
        #settings.server.port for port option
        # ugly expansion within data portion of api call, should use jq ?
        ExecStart = pkgs.writeShellScript "Initialize Radarr" ''

          until ${pkgs.curl}/bin/curl -s -X GET "http://localhost:7878/api/v3/system/status" -H 'accept: application/json'
          do
          sleep 1
          done

          ${pkgs.curl}/bin/curl -X 'PUT' 'http://localhost:7878/api/v3/config/host' \
            -H "X-Api-Key: $(${cfg.init.apikey})" \
            -H "Host: localhost:7878" \
            -H "Content-Type: application/json" \
            -d  '{
              "bindAddress": "*",
              "port": 7878,
              "sslPort": 7878,
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
              "branch": "master",
              "apiKey": "'"${cfg.init.apikey}"'",
              "sslCertPath": "",
              "sslCertPassword": "",
              "urlBase": "",
              "instanceName": "Radarr",
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

          ${pkgs.curl}/bin/curl -X POST http://localhost:7878/api/v3/rootFolder \
            -H "X-Api-Key:$(cat ${cfg.init.apikey})" \
            -H "Content-Type: application/json" \
            -d '{"path":"'"${cfg.init.rootPath}"'"}'
          ${lib.optionalString cfg.init.torrent.enable ''
            ${pkgs.curl}/bin/curl -X POST http://localhost:7878/api/v3/downloadclient \
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
                  { "name": "category", "value": "radarr" },
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
