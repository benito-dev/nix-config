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
    ./network.nix
    ../../modules/homeserver.nix
    ./zfs
    ./samba
    ./arrStack
    ./download
    ./homepage-dashboard
    ./jellyfin
    ./nginx
    ./authelia
    ./adguard
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  users = {
    users."benito" = {
      isNormalUser = true;
      description = "benito";
      extraGroups = [
        "networkmanager"
        "wheel"
        "media"
        "apps"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgpTl0n7wz58k48wHoPihIfgLzJOAydDxz6fFURN6qL"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC78SVoQExVRFtie6CHRmxgB3BgYtQ/OqLqPmA1LZvDa"
      ];
      packages = with pkgs; [ ];
    };
    groups = {
      "media" = { };
      "apps" = { };
    };
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

  environment.systemPackages = with pkgs; [
    nix-ld
    sops
    cifs-utils
    age
    python3
    nixfmt-tree
    vuetorrent
    mkcert
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    nix-ld.enable = true;
    git = {
      enable = true;
      config = {
        user = {
          name = "Benito-dev";
          email = "Benoit.Blervaque@gmail.com";
        };
        safe.directory = [ "/etc/nixos" ];
        init.defaultBranch = "main";
        core.editor = "nano";
        pull.rebase = true;
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
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
    age.keyFile = "/home/benito/.config/sops/age/keys.txt";
    secrets."cifs/credentials" = { };

  };
  system.stateVersion = "25.05";
}
