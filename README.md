# nix-config
Personal nix configuration

06/07/2025  add barebone config

07/07/2025  add sops-nix for secrets , Key to write secrets needs to be fixed, key to encrypt decrypt by system can be generated from ssh
            add cifs mount using sops for secrets, tempory hdd need to come back to main config to make nas self suficient , samba to be installed

08/07/2025  adding sonarr and qbittorrent, trouble for curl qbittorrent to sonarr, passwd qbittorrent pre generate ?
            forms variable for sonarr not working, change upper lower case ? change to forms (login page) ?

09/07/2025  used sonarr environtmentFile to pass only apikey secret, started sonarr module to configure via api calls, used wireshark to look at the packets send
            trouble expansing value contained within sops secrets path, agreed to spend time because should repeatable for rest or arr stack,
            lots of hardcoded value will expand on it later. had to understand enough about curl api calls syntax and wireshark filters

10/07/2025  Fixed Sonarr authentication, torrent downloader and root path api calls using secrets. Database should be removed from var and configured to permanent storage.
            Started qbittorrent init with secrets, password hash is annoying. Most of this is useless as the server will run behind nat with no open ports, doing it for learning experience.

12/07/2025  Using python script to generate hash, hash is generated from secrets, secrets are present after build phase, Python script must be present in nix store to be used by systemd
            while secrets are present, python script sends sigterm kill after execution to systemd service, python script has to be execute elsewhere, Prestart ? difference between Prestart and ExecPrestart and Execstart ?

13/07/2025  Error was in calling python script the wrong way, is present in nix store as a script and not a bin was calling to a file that did not exist, used python black module to
            format python script, black was used via nix-shell.