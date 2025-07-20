{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [

    ./hardware-configuration.nix
    ../common/homeserver
    ../../modules/homeserver.nix
    ./test.nix

  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader

  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1";
    useOSProber = true;
  };

  # Network

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
    defaultGateway = "192.168.0.1";
    hostId = "37740ce0";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hostName = "hms-test";
    firewall = {
      enable = true;
      allowPing = true;
    };
    interfaces = {
      enp0s31f6.ipv4.addresses = [
        {
          address = "192.168.0.230";
          prefixLength = 24;
        }
      ];
    };
  };

  sops.secrets."cifs/credentials" = { };

  # Samba Mount

  systemd.tmpfiles.rules = [
    "d /dpool/media 0770 benito media - -"
    "d /dpool/download 0770 benito media - -"
  ];

  fileSystems."/dpool/media" = {
    device = "//192.168.0.240/data";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [
        "${automount_opts},credentials=${
          config.sops.secrets."cifs/credentials".path
        },uid=benito,gid=media,dir_mode=0770,file_mode=0770"
      ];
  };

  fileSystems."/dpool/download" = {
    device = "//192.168.0.240/data";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [
        "${automount_opts},credentials=${
          config.sops.secrets."cifs/credentials".path
        },uid=benito,gid=media,dir_mode=0770,file_mode=0770"
      ];
  };

  system.stateVersion = "25.05";

}
