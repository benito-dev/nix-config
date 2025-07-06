{ config, pkgs, lib, hostname, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    nameservers = [ "195.130.131.1" "195.130.130.1" ];
    hostName = "${hostname}";
    firewall = {
      enable = true;
      allowPing = true;
    };
    interfaces = {
      enp0s31f6.ipv4.addresses = [{
        address = "192.168.0.240";
        prefixLength = 24;
      }];
    };
  };

  # Locales

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_BE.UTF-8";
      LC_IDENTIFICATION = "fr_BE.UTF-8";
      LC_MEASUREMENT = "fr_BE.UTF-8";
      LC_MONETARY = "fr_BE.UTF-8";
      LC_NAME = "fr_BE.UTF-8";
      LC_NUMERIC = "fr_BE.UTF-8";
      LC_PAPER = "fr_BE.UTF-8";
      LC_TELEPHONE = "fr_BE.UTF-8";
      LC_TIME = "fr_BE.UTF-8";
    };
  };

  time.timeZone = "Europe/Brussels";
  console.keyMap = "be-latin1";

  # Users and groups

  users.users.benito = {
    isNormalUser = true;
    description = "benito";
    extraGroups = [ "networkmanager" "wheel" "media" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgpTl0n7wz58k48wHoPihIfgLzJOAydDxz6fFURN6qL benito@tux"
    ];
    packages = with pkgs; [ ];
  };

  services.getty.autologinUser = "benito";

  security.sudo.extraRules = [{
    users = [ "benito" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  users.groups.media = { };

  # System Packages

  environment.systemPackages = with pkgs; [ nixfmt-classic nix-ld git ];

  nixpkgs.config.allowUnfree = true;
  programs = {
    nix-ld.enable = true;
    ssh = {
      startAgent = true;
      extraConfig =
        "\n      AddKeysToAgent yes\n      IdentitiesOnly yes\n      \n\n      IdentityFile ~/.ssh/nixos_key\n      ";
    };
  };

  # Services

  services = {

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  system.stateVersion = "25.05";

}
