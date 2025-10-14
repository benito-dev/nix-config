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
    "slskd" = { };
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
    serverConfig = {
      BitTorrent = {
        Session = {
          AddTorrentStopped = false;
          BandwidthSchedulerEnabled = true;
          DefaultSavePath = "/dpool/download/torrent/completed";
          DisableAutoTMMByDefault = false;
          ExcludedFileNames = "";
          GlobalDLSpeedLimit = "83008";
          GlobalMaxRatio = "0";
          GlobalUPSpeedLimit = "2930";
          IgnoreLimitsOnLAN = false;
          IncludeOverheadInLimits = false;
          LSDEnabled = false;
          MaxActiveDownloads = "5";
          MaxActiveTorrents = "5";
          MaxActiveUploads = "2";
          MaxConnections = "250";
          MaxConnectionsPerTorrent = "50";
          Port = "63586";
          Preallocation = true;
          QueueingSystemEnabled = true;
          ShareLimitAction = "Stop";
          TempPath = "/dpool/download/torrent/incoming";
          TempPathEnabled = true;
          uTPRateLimited = true;
          UseAlternativeGlobalSpeedLimit = true;
          AlternativeGlobalDLSpeedLimit = "83008";
          AlternativeGlobalUPSpeedLimit = "50";
        };
        connection = {
          GlobalDLLimitAlt = "83008";
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
  networking.firewall.allowedTCPPorts = [ 5030 ];
  services.slskd = {
    enable = false;
    openFirewall = true;
    user = "slskd";
    group = "media";
    domain = null;
    environmentFile = config.sops.secrets."slskd".path;
    settings = {
      web.authentication.apiKeys.key.key = "";
      shares.directories = [ "/dpool/media/music" ];
      directories.downloads = "/dpool/download/slskd/downloads/";
      directories.incomplete = "/dpool/download/slskd/incomplete/";
    };
  };
  systemd.services.qbittorrent = {
  serviceConfig = {
    UMask = "007";  
  };
};
}
