{ config, options, ... }:
{

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

}
