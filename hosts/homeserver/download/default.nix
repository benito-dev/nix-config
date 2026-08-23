{
  config,
  options,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./slskd.nix
    ./qbittorrent.nix
  ];
}
