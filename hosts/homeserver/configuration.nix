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
    ./arrStack
    ./download
    ./homepage-dashboard
    ./jellyfin
    ./zfs
    ./samba

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
      "195.130.131.1"
      "195.130.130.1"
    ];
    hostName = "homeserver";
    firewall = {
      enable = true;
      allowPing = true;
    };
    interfaces = {
      enp0s31f6.ipv4.addresses = [
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
    cifs-utils
    age
    python3
    nixfmt-tree
  ];

  nixpkgs.config.allowUnfree = true;
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

  fileSystems."/mnt/data" = {
    device = "//192.168.0.101/data";
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
