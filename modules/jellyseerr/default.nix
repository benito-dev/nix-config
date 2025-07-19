{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.jellyseerr;
  port = "${toString cfg.port}";
in
{
  options.services.jellyseerr.init.enable = lib.mkEnableOption "Initializing Jellyseerr";

  config = lib.mkIf (cfg.enable && cfg.init.enable) {
    #add check if already exist
    systemd.services.initJellyseerr = {
      description = "Initialize Jellyseerr";
      after = [
        "jellyseerr.service"
        "jellyfin.service"
        "initSonarr.service"
        "initRadarr.service"
      ];
      wants = [
        "jellyseerr.service"
        "jellyfin.service"
        "initSonarr.service"
        "initRadarr.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "Initialize Jellyseerr" ''
           echo "http://localhost:${port}/api/v1/status"
           # Sleep until jellyseerr is up and running

           until ${pkgs.curl}/bin/curl -s -X GET "http://localhost:${port}/api/v1/status" -H 'accept: application/json'
           do
           sleep 1
           done

           touch ${config.services.jellyseerr.configDir}/cookie.txt && cookie=${config.services.jellyseerr.configDir}/cookie.txt

           [ -s $cookie ] && cookie_sid=$(${pkgs.gawk}/bin/awk '/connect\.sid/ {print $7}' $cookie)
           [ "$(${pkgs.curl}/bin/curl  -w "%{http_code}" -s -o /dev/null  -X 'GET' "http://localhost:${port}/api/v1/auth/me" -H 'accept: application/json' -H "Cookie: connect.sid=$cookie_sid")"  -eq 200 ] || \
           ${pkgs.curl}/bin/curl -c cookie.txt -s -X 'POST' "http://localhost:${port}/api/v1/auth/jellyfin"  \
           -H 'accept: application/json' \
           -H 'Content-Type: application/json' \
           -d '{
           "username": "benito",
           "password": "test",
           "hostname": "localhost",
           "port":8096,
           "urlBase":"",
           "email": "test@gmail.com",
           "serverType": 2
           }' && cat cookie.txt > $cookie && cookie_sid=$(${pkgs.gawk}/bin/awk '/connect\.sid/ {print $7}' $cookie) 

           library_id=$(${pkgs.curl}/bin/curl -s -X 'GET' 'http://localhost:${port}/api/v1/settings/jellyfin/library?sync=sync&enable=enable' -H 'Content-Type: application/json' -H "Cookie: connect.sid=$cookie_sid")



          ${pkgs.curl}/bin/curl -s -X 'POST' "http://localhost:${port}/api/v1/settings/jellyfin" \
           -H 'accept: application/json' \
           -H 'Content-Type: application/json' \
           -H "Cookie: connect.sid=$cookie_sid" \
           -d '{
             "ip":"localhost",
             "port":8096,
             "useSsl":false,
             "urlBase":"",
             "externalHostname":"",
             "jellyfinForgotPasswordUrl":"",
             "apiKey":"'"$(cat ${config.sops.secrets."jellyfin/apikey".path})"'" 
           }'

          [ ! $(${pkgs.curl}/bin/curl -s -X 'GET' "http://localhost:${port}/api/v1/settings/radarr/" \
           -H 'accept: application/json' \
           -H 'Content-Type: application/json' \
           -H "Cookie: connect.sid=$cookie_sid") == "[]" ] || \
           ${pkgs.curl}/bin/curl -s -X 'POST' "http://localhost:${port}/api/v1/settings/radarr/" \
           -H 'accept: application/json' \
           -H 'Content-Type: application/json' \
           -H "Cookie: connect.sid=$cookie_sid" \
           -d '{
             "name":"Radarr",
             "hostname":"localhost",
             "port": ${toString config.services.radarr.settings.server.port},
             "apiKey":"'"$(cat ${config.sops.secrets."radarr/apikey".path})"'",
             "useSsl":false,"activeProfileId":7,
             "activeProfileName":"Main",
             "activeDirectory":"'"${config.services.radarr.init.rootPath}"'",
             "is4k":false,
             "minimumAvailability":"released",
             "tags":[],
             "isDefault":true,
             "syncEnabled":true,
             "preventSearch":false,
             "tagRequests":false
           }' 

          [ ! $(${pkgs.curl}/bin/curl -s -X 'GET' "http://localhost:${port}/api/v1/settings/sonarr/" \
           -H 'accept: application/json' \
           -H 'Content-Type: application/json' \
           -H "Cookie: connect.sid=$cookie_sid") == "[]" ] || \
          ${pkgs.curl}/bin/curl -s -X 'POST' "http://localhost:${port}/api/v1/settings/sonarr/" \
           -H 'accept: application/json' \
           -H 'Content-Type: application/json' \
           -H "Cookie: connect.sid=$cookie_sid" \
           -d '{
             "name":"Sonarr",
             "hostname":"localhost",
             "port": ${toString config.services.sonarr.settings.server.port},
             "apiKey":"'"$(cat ${config.sops.secrets."sonarr/apikey".path})"'",
             "useSsl":false,"activeProfileId":7,
             "activeProfileName":"Main",
             "activeDirectory":"'"${config.services.sonarr.init.rootPath}"'",
             "activeAnimeProfileName":"",
             "activeAnimeDirectory":"",
             "tags":[],
             "animeTags":[],
             "is4k":false,
             "isDefault":true,
             "enableSeasonFolders":true,
             "syncEnabled":true,
             "preventSearch":false,
             "tagRequests":false
           }' 
        '';
      };
    };
  };
}
