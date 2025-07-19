{
  config,
  options,
  lib,
  pkgs,
  ...
}:

{
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
    vuetorrent = true;
    settings = {

      BitTorrent = {
        "Session\\AddTorrentStopped" = "false";
        "Session\\BTProtocol" = "TCP";
        "Session\\BandwidthSchedulerEnabled" = "true";
        "Session\\DefaultSavePath" = "/mnt/download/torrent/completed";
        "Session\\DisableAutoTMMByDefault" = "false";
        "Session\\DisableAutoTMMTriggers\\CategorySavePathChanged" = "false";
        "Session\\DisableAutoTMMTriggers\\DefaultSavePathChanged" = "false";
        "Session\\ExcludedFileNames" = "";
        "Session\\GlobalDLSpeedLimit" = "83008";
        "Session\\GlobalMaxRatio" = "0";
        "Session\\GlobalUPSpeedLimit" = "2930";
        "Session\\IgnoreLimitsOnLAN" = "false";
        "Session\\IncludeOverheadInLimits" = "false";
        "Session\\LSDEnabled" = "false";
        "Session\\MaxActiveDownloads" = "10";
        "Session\\MaxActiveTorrents" = "20";
        "Session\\MaxActiveUploads" = "2";
        "Session\\MaxConnections" = "1000";
        "Session\\MaxConnectionsPerTorrent" = "100";
        "Session\\Port" = "63586";
        "Session\\Preallocation" = "true";
        "Session\\QueueingSystemEnabled" = "true";
        "Session\\SSL\\Port" = "29544";
        "Session\\ShareLimitAction" = "Stop";
        "Session\\TempPath" = "/mnt/download/torrent/incoming";
        "Session\\TempPathEnabled" = "true";
        "Session\\uTPRateLimited" = "true";
        "Connection\\GlobalDLLimitAlt" = "83008";
        "Connection\\GlobalUPLimitAlt" = "1024";
        "Scheduler\\Enabled" = "true";
        "Scheduler\\start_time" = "0";
        "Scheduler\\end_time" = "1020";
        "Scheduler\\days" = "1234567";
        "Session\\UseAlternativeGlobalSpeedLimit" = "true";
        "Session\\AlternativeGlobalDLSpeedLimit" = "83008";
        "Session\\AlternativeGlobalUPSpeedLimit" = "50";
      };

      Core = {
        "AutoDeleteAddedTorrentFile" = "Always";
      };

      Preferences = {
        "WebUI\\AuthSubnetWhitelist" = "192.168.0.0/24";
        "WebUI\\AuthSubnetWhitelistEnabled" = "true";
        "WebUI\\LocalHostAuth" = "false";
        "Scheduler\\end_time" = "@Variant(\\0\\0\\0\\xf\\0\\0\\0\\0)";
        "Scheduler\\start_time" = "@Variant(\\0\\0\\0\\xf\\x3\\xa5\\xd6\\x80)";
      };
    };
  };
}
