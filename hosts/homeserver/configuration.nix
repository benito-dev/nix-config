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
    ../../modules/homeserver.nix
    ../common/homeserver
    ./zfs
    ./samba
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network

  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    defaultGateway = "192.168.0.1";
    hostId = "37740ce0";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    hostName = "homeserver";
    firewall = {
      enable = true;
      allowPing = true;
    };
    bridges."br0".interfaces = [
      "enp6s0"
      "enp7s0"
      "enp8s0"
      "enp9s0"
      "enp12s0"
    ];
    interfaces = {
      "br0".ipv4.addresses = [
        {
          address = "192.168.0.240";
          prefixLength = 24;
        }
      ];
    };
  };

  system.stateVersion = "25.05";

}
