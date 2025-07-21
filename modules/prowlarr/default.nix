{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.prowlarr;

in
{
  options.services.prowlarr = {
    init = {
      enable = lib.mkEnableOption "Initializing prowlarr Authentication";

      apikey = lib.mkOption {
        description = "prowlarr api key, can be initialized via services.sonarr.environmentFiles, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."prowlarr/apikey".path})";
      };

      username = lib.mkOption {
        description = "prowlarr user, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."prowlarr/username".path})";
      };

      password = lib.mkOption {
        description = "prowlarr password, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."prowlarr/password".path})";
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
    };
  };

  config = lib.mkIf cfg.init.enable {
    systemd.services.initProwlarr = {
      description = "Initialize prowlarr";
      after = [ "prowlarr.service" ];
      wants = [ "prowlarr.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "Initialize prowlarr" ''

          until ${pkgs.curl}/bin/curl -s -X GET "http://localhost:${toString cfg.settings.server.port}/api/v1/system/status" -H 'accept: application/json'
          do
          sleep 1
          done

          ${pkgs.curl}/bin/curl  -X 'PUT' "http://localhost:${toString cfg.settings.server.port}/api/v1/config/host" \
          -H "X-Api-Key: $(${cfg.init.apikey})" \
          -H "Host: localhost:8686" \
          -H "Content-Type: application/json" \
          -d  '{
              "bindAddress": "*",
              "port": '${toString cfg.settings.server.port}',
              "sslPort": '${toString cfg.settings.server.port}',
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
              "instanceName": "Prowlarr",
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

           ${pkgs.curl}/bin/curl  -X POST "http://localhost:${toString cfg.settings.server.port}/api/v1/downloadclient" \
           -H "X-Api-Key: $(${cfg.init.apikey})" \
           -H "Content-Type: application/json" \
           -d '{
           "enable":true,
           "protocol":"torrent",
           "priority":1,
           "categories":[],
           "supportsCategories":true,
           "name":"qBittorrent",
           "fields":[
               {"name":"host","value":"localhost"},
               {"name":"port","value":8080},
               {"name":"useSsl","value":false},
               {"name":"urlBase"},
               {"name": "username", "value": "'"${config.services.qbittorrent.username}"'"},
               {"name": "password", "value": "'"${config.services.qbittorrent.password}"'"},
               {"name":"category","value":"prowlarr"},
               {"name":"priority","value":0},
               {"name":"initialState","value":0},
               {"name":"sequentialOrder","value":false},
               {"name":"firstAndLast","value":false},
               {"name":"contentLayout","value":0}],
           "implementationName":"qBittorrent",
           "implementation":"QBittorrent",
           "configContract":"QBittorrentSettings",
           "infoLink":"https://wiki.servarr.com/prowlarr/supported#qbittorrent",
           "tags":[]
           }'

           ${pkgs.curl}/bin/curl  -X POST "http://localhost:${toString cfg.settings.server.port}/api/v1/indexerProxy?" \
           -H "X-Api-Key: $(${cfg.init.apikey})" \
           -H "Content-Type: application/json" \
           -d '{
           "onHealthIssue":false,
           "supportsOnHealthIssue":false,
           "includeHealthWarnings":false,
           "name":"FlareSolverr",
           "fields":[
           {"name":"host","value":"http://localhost:8191/"},
           {"name":"requestTimeout","value":60}],
           "implementationName":"FlareSolverr",
           "implementation":"FlareSolverr",
           "configContract":"FlareSolverrSettings",
           "infoLink":"https://wiki.servarr.com/prowlarr/supported#flaresolverr",
           "tags":[1]
           }'

           ${pkgs.curl}/bin/curl  -X POST "http://localhost:${toString cfg.settings.server.port}/api/v1/applications?" \
           -H "X-Api-Key: ${cfg.init.apikey}" \
           -H "Content-Type: application/json" \
           -d '{
           "syncLevel":"fullSync",
           "enable":true,
           "fields":[
           {"name":"prowlarrUrl","value":"'"http://localhost:${toString cfg.settings.server.port}"'"},
           {"name":"baseUrl","value":"'"http://localhost:${toString config.services.radarr.settings.server.port}"'"},
           {"name":"apiKey","value":"'"${config.services.radarr.init.apikey}"'"},
           {"name":"syncCategories","value":[2000,2010,2020,2030,2040,2045,2050,2060,2070,2080,2090]},
           {"name":"syncRejectBlocklistedTorrentHashesWhileGrabbing","value":false}],
           "implementationName":"Radarr",
           "implementation":"Radarr",
           "configContract":"RadarrSettings",
           "infoLink":"https://wiki.servarr.com/prowlarr/supported#radarr",
           "tags":[],
           "name":"Radarr"
           }'

           ${pkgs.curl}/bin/curl -X POST "http://localhost:${toString cfg.settings.server.port}/api/v1/applications?" \
           -H "X-Api-Key: ${cfg.init.apikey}" \
           -H "Content-Type: application/json" \
           -d '{
           "syncLevel":"fullSync",
           "enable":true,
           "fields":[
           {"name":"prowlarrUrl","value":"'"http://localhost:${toString cfg.settings.server.port}"'"},
           {"name":"baseUrl","value":"'"http://localhost:${toString config.services.sonarr.settings.server.port}"'"},
           {"name":"apiKey","value":"'"${config.services.sonarr.init.apikey}"'"},
           {"name":"syncCategories","value":[5000,5010,5020,5030,5040,5045,5050,5090]},
           {"name":"animeSyncCategories","value":[5070]},
           {"name":"syncAnimeStandardFormatSearch","value":true},
           {"name":"syncRejectBlocklistedTorrentHashesWhileGrabbing","value":false}],
           "implementationName":"Sonarr",
           "implementation":"Sonarr",
           "configContract":"SonarrSettings",
           "infoLink":"https://wiki.servarr.com/prowlarr/supported#sonarr",
           "tags":[],
           "name":"Sonarr"
           }'
        '';
      };
    };
  };
}
