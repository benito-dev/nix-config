{ lib, pkgs, inputs, ... }:

{

  imports = [ inputs.declarative-jellyfin.nixosModules.default ];

  services.declarative-jellyfin = {
    # Move metadate to statefull storage
    enable = true;
    serverId = "9069974d38f842ddad31cd6bf88180c4";
    group = "media";
    openFirewall = true;

    system = { serverName = "JellyNix"; };
    users.benito = {
      mutable = false;
      password = "test";
      permissions.isAdministrator = true;
    };
    libraries = {
      "Movies" = {
        enabled = true;
        contentType = "movies";
        pathInfos = [ "/mnt/test" ];
        preferredMetadataLanguage = "fr";
        enableChapterImageExtraction = true;
        extractChapterImagesDuringLibraryScan = true;
        enableTrickplayImageExtraction = true;
        extractTrickplayImagesDuringLibraryScan = true;
        saveTrickplayWithMedia = true;

      };
    };
  };
}
