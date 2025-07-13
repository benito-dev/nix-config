{ config, options, lib, pkgs, ... }:

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
        "Session\\DefaultSavePath" = "/mnt/data/torrent/completed";
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
        "Session\\MaxConnections" = "1500";
        "Session\\MaxConnectionsPerTorrent" = "250";
        "Session\\Port" = "63586";
        "Session\\Preallocation" = "true";
        "Session\\QueueingSystemEnabled" = "true";
        "Session\\SSL\\Port" = "29544";
        "Session\\ShareLimitAction" = "Stop";
        "Session\\TempPath" = "/mnt/data/torrent/incoming";
        "Session\\TempPathEnabled" = "true";
        "Session\\UseAlternativeGlobalSpeedLimit" = "false";
        "Session\\uTPRateLimited" = "true";

      };
      Core = { "AutoDeleteAddedTorrentFile" = "Always"; };
      Preferences = {
        "WebUI\\AlternativeUIEnabled" = "true";
        "WebUI\\AuthSubnetWhitelist" = "192.168.0.0/24";
        "WebUI\\AuthSubnetWhitelistEnabled" = "true";
        "WebUI\\LocalHostAuth" = "false";
        "WebUI\\RootFolder" = "/var/lib/qBittorrent/qBittorrent/vuetorrent";
      };
    };
  };
}

