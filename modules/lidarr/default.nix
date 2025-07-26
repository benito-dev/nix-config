{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.lidarr;

in
{
  options.services.lidarr = {
    init = {
      enable = lib.mkEnableOption "Initializing lidarr Authentication";

      apikey = lib.mkOption {
        description = "lidarr api key, can be initialized via services.sonarr.environmentFiles, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."lidarr/apikey".path})";
      };

      username = lib.mkOption {
        description = "lidarr user, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."lidarr/username".path})";
      };

      password = lib.mkOption {
        description = "lidarr password, defaults to sops secret";
        type = lib.types.str;
        default = "$(cat ${config.sops.secrets."lidarr/password".path})";
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
        default = "/dpool/media/music";
      };
      torrent.enable = lib.mkEnableOption "Initializing qBitorrent";
    };
  };

  config = lib.mkIf cfg.init.enable {
    systemd.services.initlidarr = {
      description = "Initialize lidarr";
      after = [ "lidarr.service" ];
      wants = [ "lidarr.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        #will update along the way when the need arises
        #settings.server.port for port option
        # ugly expansion within data portion of api call, should use jq ?
        ExecStart = pkgs.writeShellScript "Initialize lidarr" ''

          until ${pkgs.curl}/bin/curl -s -X GET "http://localhost:${toString cfg.settings.server.port}/api/v1/system/status" -H 'accept: application/json'
          do
          sleep 1
          done

          ${pkgs.curl}/bin/curl -X 'PUT' "http://localhost:${toString cfg.settings.server.port}/api/v1/config/host" \
            -H "X-Api-Key: ${cfg.init.apikey}" \
            -H "Host: localhost:${toString cfg.settings.server.port}" \
            -H "Content-Type: application/json" \
            -d  '{
              "bindAddress": "*",
              "port": '${toString cfg.settings.server.port}',
              "sslPort": '${toString cfg.settings.server.port}' ,
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
              "instanceName": "Lidarr",
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
        '';
      };
    };
  };
}
