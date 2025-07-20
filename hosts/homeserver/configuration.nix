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
    bridges."br0".interfaces = [ "enp6s0" "enp7s0" "enp8s0" "enp9s0" "enp12s0" ];
    interfaces = {
      "br0".ipv4.addresses = [
        {
          address = "192.168.0.240";
          prefixLength = 24;
        }
      ];
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgpTl0n7wz58k48wHoPihIfgLzJOAydDxz6fFURN6qL benito@tux"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC78SVoQExVRFtie6CHRmxgB3BgYtQ/OqLqPmA1LZvDa azureadbenoitblervaque@PC000033"
    ];
    packages = with pkgs; [ ];
  };

  services.getty.autologinUser = "benito";

  security.sudo.extraRules = [
    {
      users = [ "benito" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  users.groups.media = { };

  # System Packages

  environment.systemPackages = with pkgs; [
    nixfmt-classic
    nix-ld
    git
    sops
    age
    python3
    nixfmt-tree
  ];  nixpkgs.config.allowUnfree = true;
  programs = {
    nix-ld.enable = true;
    ssh = {
      startAgent = true;
      extraConfig = "\n      AddKeysToAgent yes\n      IdentitiesOnly yes\n      \n\n      IdentityFile ~/.ssh/nixos_key\n      ";
    };
  };

  # Services

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  extraServices.podman.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;

    age = {
      keyFile = "/home/benito/.config/sops/age/keys.txt";
      # Later create a host level sops for only decrypting secrets and user lvl sops for creating secrets
      #sshKeyPaths = [ "/home/benito/.ssh/nixos-key" ];
      #keyFile = "/var/lib/sops-nix/key.txt";
      #generateKey = true;
    };
    secrets = {
      "cifs/credentials" = { };
      "qbittorrent/username" = { };
      "qbittorrent/password" = { };
    };
  };

  # Samba Mount

  system.stateVersion = "25.05";

}
