{ config, options, inputs, ... }:

{

  imports = [ inputs.declarative-jellyfin.nixosModules.default ];

  sops.secrets = {
    "jellyfin/apikey" = { };
    "jellyfin/benito/password" = { };
  };

  users.users.jellyfin.extraGroups = [ "video" "render" ];

  services.declarative-jellyfin = {
    # Move metadate to statefull storage
    enable = true;
    serverId = "9069974d38f842ddad31cd6bf88180c4";
    group = "media";
    openFirewall = true;

    system = {
      serverName = "JellyNix";
      isStartupWizardCompleted = true;
    };

    libraries = {
      Movies = {
        enabled = true;
        contentType = "movies";
        pathInfos = [ "/mnt/data/media/movies" ];
      };

      Series = {
        enabled = true;
        contentType = "tvshows";
        pathInfos = [ "/mnt/data/media/tvshows" ];
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
