{
  config,
  options,
  inputs,
  ...
}:

{

  imports = [ inputs.declarative-jellyfin.nixosModules.default ];

  sops.secrets = {
    "jellyfin/apikey" = { };
    "jellyfin/benito/password" = { };
  };

  users.users.jellyfin.extraGroups = [
    "video"
    "render"
    "apps"
  ];
  hardware.graphics.enable = true;
  services.declarative-jellyfin = {
    # Move metadata to zfs raid
    enable = true;
    serverId = "9069974d38f842ddad31cd6bf88180c4";
    group = "media";
    openFirewall = true;

    system = {
      serverName = "JellyNix";
      isStartupWizardCompleted = true;
    };
    encoding = {
      enableHardwareEncoding = true;
      hardwareAccelerationType = "vaapi";
      enableDecodingColorDepth10Hevc = true;
      allowHevcEncoding = true;
      hardwareDecodingCodecs = [
        "h264"
        "hevc"
        "mpeg2video"
        "vc1"
        "vp9"
      ];
    };

    libraries = {
      Movies = {
        enabled = true;
        contentType = "movies";
        pathInfos = [ "/dpool/media/movies" ];
      };

      Series = {
        enabled = true;
        contentType = "tvshows";
        pathInfos = [ "/dpool/media/tvshows" ];
      };
    };

    users.benito = {
      mutable = false;
      hashedPasswordFile = config.sops.secrets."jellyfin/benito/password".path;
      permissions.isAdministrator = true;
    };

    apikeys.Main.keyPath = config.sops.secrets."jellyfin/apikey".path;

  };
}
