{
  config,
  options,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "qbittorrent/username" = { };
    "qbittorrent/password" = { };
  };

  services.qbittorrent = {
    enable = true;
    group = "media";
    serverConfig = {
      BitTorrent = {
        Session = {
          AddTorrentStopped = false;
          BandwidthSchedulerEnabled = true;
          DefaultSavePath = "/dpool/download/torrent/completed";
          DisableAutoTMMByDefault = false;
          ExcludedFileNames = "";
          GlobalDLSpeedLimit = "53711";
          GlobalMaxRatio = "0";
          GlobalUPSpeedLimit = "5371";
          IgnoreLimitsOnLAN = false;
          IncludeOverheadInLimits = false;
          LSDEnabled = false;
          MaxActiveDownloads = "15";
          MaxActiveTorrents = "20";
          MaxActiveUploads = "5";
          MaxConnections = "2000";
          MaxConnectionsPerTorrent = "100";
          Port = "63586";
          Preallocation = true;
          QueueingSystemEnabled = true;
          ShareLimitAction = "Stop";
          TempPath = "/dpool/download/torrent/incoming";
          TempPathEnabled = true;
          uTPRateLimited = true;
          UseAlternativeGlobalSpeedLimit = true;
          AlternativeGlobalDLSpeedLimit = "53711";
          AlternativeGlobalUPSpeedLimit = "976";
        };
        connection = {
          GlobalDLLimitAlt = "53711";
          GlobalUPLimitAlt = "1024";
        };
        Scheduler = {
          Enabled = "true";
          start_time = "0";
          end_time = "1020";
          days = "1234567";
        };
      };

      Core = {
        AutoDeleteAddedTorrentFile = "Always";
      };

      Preferences = {
        WebUI = {
          user = "$(cat ${config.sops.secrets."qbittorrent/username".path})";
          Password_PBKDF2 = "cRbEJViCltS1XgJ0KxR6ig==:gR1mSRs6XFivZDwtNo0mregop+DB0PheaA7abFtdfo9idt/EF1xTNgnAx+cAqQmfxcEdQReLjIckbGXGofryqA==";
          AuthSubnetWhitelist = "192.168.0.0/24";
          AuthSubnetWhitelistEnabled = true;
          LocalHostAuth = false;
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        };
        Scheduler = {
          end_time = "@Variant(\\0\\0\\0\\xf\\0\\0\\0\\0)";
          start_time = "@Variant(\\0\\0\\0\\xf\\x3\\xa5\\xd6\\x80)";
        };
      };
    };
  };
  systemd.services = {
    qbittorrent = {
      serviceConfig = {
        UMask = "007";
      };
    };
  };
}
