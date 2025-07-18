{ config, options, ... }:
{

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };
    autoSnapshot = {
      enable = true;
      hourly = 24; # Keep 24 hourly snapshots
    };
  };

}
