{ config, options, ... }:

{
  sops.secrets = {
    "sonarr/apikey" = { };
    "sonarr/username" = { };
    "sonarr/password" = { };
    "sonarr/ENV/apikey" = { };
    "radarr/apikey" = { };
    "radarr/username" = { };
    "radarr/password" = { };
    "radarr/ENV/apikey" = { };
    "prowlarr/ENV/apikey" = { };

  };

  services.sonarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [ config.sops.secrets."sonarr/ENV/apikey".path ];
  };

  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
    init.enable = true;
    init.torrent.enable = true;
    environmentFiles = [ config.sops.secrets."radarr/ENV/apikey".path ];
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
    #init.enable = true;
    environmentFiles = [ config.sops.secrets."prowlarr/ENV/apikey".path ];

  };

  systemd.services.recyclarr.serviceConfig.LoadCredential = [
    "sonarr-api_key:${config.sops.secrets."sonarr/apikey".path}"
    "radarr-api_key:${config.sops.secrets."radarr/apikey".path}"
  ];

  services.recyclarr.enable = true;
  services.recyclarr.configuration = {
    sonarr = {
      sonarr_main = {
        base_url = "http://localhost:${
            toString config.services.sonarr.settings.server.port
          }";
        api_key._secret = "/run/credentials/recyclarr.service/sonarr-api_key";
        quality_definition = { type = "series"; };
        delete_old_custom_formats = true;
        replace_existing_custom_formats = true;

        quality_profiles = [{
          name = "Main";
          reset_unmatched_scores = { enabled = true; };
          upgrade = {
            allowed = true;
            until_quality = "BLuray-2160p Remux";
          };
          # min_format_score = 100;
          qualities = [
            { name = "Bluray-2160p Remux"; }
            { name = "Bluray-2160p"; }
            {
              name = "WEB 2160p";
              qualities = [ "WEBRip-2160p" "WEBDL-2160p" ];
            }
            { name = "HDTV-2160p"; }
            { name = "Bluray-1080p Remux"; }
            { name = "Bluray-1080p"; }
            {
              name = "WEB 1080p";
              qualities = [ "WEBRip-1080p" "WEBDL-1080p" ];
            }
            { name = "HDTV-1080p"; }
            { name = "Bluray-720p"; }
            {
              name = "WEB 720p";
              qualities = [ "WEBRip-720p" "WEBDL-720p" ];
            }
            { name = "HDTV-720p"; }
          ];
        }];

        media_naming = {
          series = "default";
          season = "default";
          episodes = {
            rename = true;
            standard = "default";
            daily = "default";
            anime = "default";
          };
        };

        custom_formats = [{
          trash_ids = [

            "5d9fd1b1e06cd8a475462f40214b7df6" # FLUX

            # "Audio" Channels
            "bd6dd5e043aa27ff4696a08d011c7d96" # 1.0 Mono
            "834e534f103938853ffced4203b53e72" # 2.0 Stereo
            "42cba7e38c7947a6d1d0a62580ee6d62" # 3.0 Sound
            "1895195e84767de180653914ce207245" # 4.0 Sound
            "3fbafa924f361e66fbc6187af82dfa85" # 5.1 Surround
            "9fb6d778592c293467437593ef394bf1" # 6.1 Surround
            "204c8c3e7315bb0ea81332774fa888d6" # 7.1 Surround

            # "Audio" Formats
            "a50b8a0c62274a7c38b09a9619ba9d86" # AAC
            "b6fbafa7942952a13e17e2b1152b539a" # ATMOS (undefined)
            "dbe00161b08a25ac6154c55f95e6318d" # DD
            "63487786a8b01b7f20dd2bc90dd4a477" # DD+
            "4232a509ce60c4e208d13825b7c06264" # DD+ ATMOS
            "5964f2a8b3be407d083498e4459d05d0" # DTS
            "9d00418ba386a083fbf4d58235fc37ef" # DTS X
            "c1a25cd67b5d2e08287c957b1eb903ec" # DTS-ES
            "cfa5fbd8f02a86fc55d8d223d06a5e1f" # DTS-HD HRA
            "c429417a57ea8c41d57e6990a8b0033f" # DTS-HD MA
            "851bd64e04c9374c51102be3dd9ae4cc" # FLAC
            "3e8b714263b26f486972ee1e0fe7606c" # MP3
            "28f6ef16d61e2d1adfce3156ed8257e3" # Opus
            "30f70576671ca933adbdcfc736a69718" # PCM
            "1808e4b9cee74e064dfae3f1db99dbfe" # TrueHD
            "0d7824bb924701997f874e7ff7d4844a" # TrueHD ATMOS

            # "HDR" Formats
            "6d0d8de7b57e35518ac0308b0ddf404e" # DV
            "7878c33f1963fefb3d6c8657d46c2f0a" # DV HDR10
            "2b239ed870daba8126a53bd5dc8dc1c8" # DV HDR10+
            "1f733af03141f068a540eec352589a89" # DV HLG
            "27954b0a80aab882522a88a4d9eae1cd" # DV SDR
            "3e2c4e748b64a1a1118e0ea3f4cf6875" # HDR
            "bb019e1cd00f304f80971c965de064dc" # HDR (undefined)
            "3497799d29a085e2ac2df9d468413c94" # HDR10
            "a3d82cbef5039f8d295478d28a887159" # HDR10+
            "17e889ce13117940092308f48b48b45b" # HLG
            "2a7e3be05d3861d6df7171ec74cad727" # PQ

            # "HDR" Optional

            "9b27ab6498ec0f31a3353992e19434ca" # DV (WEBDL)

            # "HQ" Source Groups
            "d6819cba26b1a6508138d25fb5e32293" # HD Bluray Tier 01
            "c2216b7b8aa545dc1ce8388c618f8d57" # HD Bluray Tier 02
            "9965a052eb87b0d10313b1cea89eb451" # Remux Tier 01
            "8a1d0c3d7497e741736761a1da866a2e" # Remux Tier 02
            "d0c516558625b04b363fa6c5c2c7cfd4" # WEB Scene
            "e6258996055b9fbab7e9cb2f75819294" # WEB Tier 01
            "58790d4e2fdcd9733aa7ae68ba2bb503" # WEB Tier 02
            "d84935abd3f8556dcd51d4f27e22d0a6" # WEB Tier 03

            # "Miscellaneous"
            "290078c8b266272a5cc8e251b5e2eb0b" # 1080p
            "1bef6c151fa35093015b0bfef18279e5" # 2160p
            "c99279ee27a154c2f20d1d505cc99e25" # 720p
            "eb3d5cc0a2be0db205fb823640db6a3c" # Repack v2
            "44e7c4de10ae50265753082e5dc76047" # Repack v3
            "ec8fa7296b64e8cd390a1600981f3923" # Repack/Proper
            "3bc5f395426614e155e585a2f056cdf1" # Season Pack
            "7470a681e6205243983c4410ee4c920f" # VC-1
            "90501962793d580d011511155c97e4e5" # VP9
            "cddfb4e32db826151d97352b8e37c648" # x264
            "c9eafd50846d299b862ca9bb6ea91950" # x265

            # "Unwanted"
            "15a05bc7c1a36e2b57fd628f8977e2fc" # AV1
            "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
            "fbcb31d8dabd2a319072b84fc0b7249c" # Extras
            "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
            "e2315f990da2e2cbfc9fa5b7a6fcfe48" # LQ (Release Title)
            "23297a736ca77c0fc8e70f8edd7ee56c" # Upscaled
            "47435ece6b99a0b477caf360e79ba0bb" # x265 (HD)
          ];
          assign_scores_to = [{ name = "Main"; }];
        }];
      };
    };

    radarr = {
      radarr_main = {
        base_url = "http://localhost:${
            toString config.services.radarr.settings.server.port
          }";
        api_key._secret = "/run/credentials/recyclarr.service/radarr-api_key";
        quality_definition = { type = "movie"; };
        delete_old_custom_formats = true;
        replace_existing_custom_formats = true;
        quality_profiles = [{
          name = "Main";
          reset_unmatched_scores = { enabled = true; };
          upgrade = {
            allowed = true;
            until_quality = "Remux-2160p";
          };
          min_format_score = 100;
          qualities = [
            { name = "Remux-2160p"; }
            { name = "Bluray-2160p"; }
            {
              name = "WEB 2160p";
              qualities = [ "WEBRip-2160p" "WEBDL-2160p" ];
            }
            { name = "HDTV-2160p"; }
            { name = "Remux-1080p"; }
            { name = "Bluray-1080p"; }
            {
              name = "WEB 1080p";
              qualities = [ "WEBRip-1080p" "WEBDL-1080p" ];
            }
            { name = "HDTV-1080p"; }
            { name = "Bluray-720p"; }
            {
              name = "WEB 720p";
              qualities = [ "WEBRip-720p" "WEBDL-720p" ];
            }
            { name = "HDTV-720p"; }
          ];
        }];
        media_naming = {
          movie = {
            rename = true;
            standard = "default";
          };
        };
        custom_formats = [{
          trash_ids = [

            # [No Category]
            "5153ec7413d9dae44e24275589b5e944" # BHDStudio
            "e098247bc6652dd88c76644b275260ed" # FLUX
            "ff5bc9e8ce91d46c997ca3ac6994d6f8" # FraMeSToR
            "7a0d1ad358fee9f5b074af3ef3f9d9ef" # hallowed
            "8cd3ac70db7ac318cf9a0e01333940a4" # SiC

            # Audio Channels
            "b124be9b146540f8e62f98fe32e49a2a" # 1.0 Mono
            "89dac1be53d5268a7e10a19d3c896826" # 2.0 Stereo
            "205125755c411c3b8622ca3175d27b37" # 3.0 Sound
            "373b58bd188fc00c817bd8c7470ea285" # 4.0 Sound
            "77ff61788dfe1097194fd8743d7b4524" # 5.1 Surround
            "6fd7b090c3f7317502ab3b63cc7f51e3" # 6.1 Surround
            "e77382bcfeba57cb83744c9c5449b401" # 7.1 Surround

            # Audio Formats
            "240770601cc226190c367ef59aba7463" # AAC
            "417804f7f2c4308c1f4c5d380d4c4475" # ATMOS (undefined)
            "c2998bd0d90ed5621d8df281e839436e" # DD
            "185f1dd7264c4562b9022d963ac37424" # DD+
            "1af239278386be2919e1bcee0bde047e" # DD+ ATMOS
            "1c1a4c5e823891c75bc50380a6866f73" # DTS
            "2f22d89048b01681dde8afe203bf2e95" # DTS X
            "f9f847ac70a0af62ea4a08280b859636" # DTS-ES
            "8e109e50e0a0b83a5098b056e13bf6db" # DTS-HD HRA
            "dcf3ec6938fa32445f590a4da84256cd" # DTS-HD MA
            "a570d4a0e56a2874b64e5bfa55202a1b" # FLAC
            "6ba9033150e7896bdc9ec4b44f2b230f" # MP3
            "a061e2e700f81932daf888599f8a8273" # Opus
            "e7c2fcae07cbada050a0af3357491d7b" # PCM
            "3cafb66171b47f226146a0770576870f" # TrueHD
            "496f355514737f7d83bf7aa4d24f8169" # TrueHD ATMOS

            # General Streaming Services
            "b3b3a6ac74ecbd56bcdbefa4799fb9df" # AMZN
            "40e9380490e748672c2522eaaeb692f7" # ATVP
            "cc5e51a9e85a6296ceefe097a77f12f4" # BCORE
            "16622a6911d1ab5d5b8b713d5b0036d4" # CRiT
            "84272245b2988854bfb76a16e60baea5" # DSNP
            "509e5f41146e278f9eab1ddaceb34515" # HBO
            "5763d1b0ce84aff3b21038eea8e9b8ad" # HMAX
            "526d445d4c16214309f0fd2b3be18a89" # Hulu
            "e0ec9672be6cac914ffad34a6b077209" # iT
            "2a6039655313bf5dab1e43523b62c374" # MA
            "6a061313d22e51e0f25b7cd4dc065233" # MAX
            "170b1d363bd8516fbf3a3eb05d4faff6" # NF
            "c9fd353f8f5f1baf56dc601c4cb29920" # PCOK
            "e36a0ba1bc902b26ee40818a1d59b8bd" # PMTP
            "c2863d2a50c9acad1fb50e53ece60817" # STAN

            # HDR Formats
            "58d6a88f13e2db7f5059c41047876f00" # DV
            "e23edd2482476e595fb990b12e7c609c" # DV HDR10
            "c53085ddbd027d9624b320627748612f" # DV HDR10+
            "55d53828b9d81cbe20b02efd00aa0efd" # DV HLG
            "a3e19f8f627608af0211acd02bf89735" # DV SDR
            "e61e28db95d22bedcadf030b8f156d96" # HDR
            "2a4d9069cc1fe3242ff9bdaebed239bb" # HDR (undefined)
            "dfb86d5941bc9075d6af23b09c2aeecd" # HDR10
            "b974a6cd08c1066250f1f177d7aa1225" # HDR10+
            "9364dd386c9b4a1100dde8264690add7" # HLG
            "08d6d8834ad9ec87b1dc7ec8148e7a1f" # PQ

            # HQ Release Groups
            "ed27ebfef2f323e964fb1f61391bcb35" # HD Bluray Tier 01
            "c20c8647f2746a1f4c4262b0fbbeeeae" # HD Bluray Tier 02
            "5608c71bcebba0a5e666223bae8c9227" # HD Bluray Tier 03
            "3a3ff47579026e76d6504ebea39390de" # Remux Tier 01
            "9f98181fe5a3fbeb0cc29340da2a468a" # Remux Tier 02
            "8baaf0b3142bf4d94c42a724f034e27a" # Remux Tier 03
            "4d74ac4c4db0b64bff6ce0cffef99bf0" # UHD Bluray Tier 01
            "a58f517a70193f8e578056642178419d" # UHD Bluray Tier 02
            "e71939fae578037e7aed3ee219bbe7c1" # UHD Bluray Tier 03
            "c20f169ef63c5f40c2def54abaf4438e" # WEB Tier 01
            "403816d65392c79236dcb6dd591aeda4" # WEB Tier 02
            "af94e0fe497124d1f9ce732069ec8c3b" # WEB Tier 03

            # Miscellaneous
            "e7718d7a3ce595f289bfee26adc178f5" # Repack/Proper
            "ae43b294509409a6a13919dedd4764c4" # Repack2
            "5caaaa1c08c1742aa4342d8c4cc463f2" # Repack3
            "2899d84dc9372de3408e6d8cc18e9666" # x264
            "9170d55c319f4fe40da8711ba9d8050d" # x265

            # Unwanted
            "b8cd450cbfa689c0259a01d9e29ba3d6" # 3D
            "cae4ca30163749b891686f95532519bd" # AV1
            "ed38b889b31be83fda192888e2286d83" # BR-DISK
            "0a3f082873eb454bde444150b70253cc" # Extras
            "e6886871085226c3da1830830146846c" # Generated Dynamic HDR
            "90a6f9a284dff5103f6346090e6280c8" # LQ
            "e204b80c87be9497a8a6eaff48f72905" # LQ (Release Title)
            "712d74cd88bceb883ee32f773656b1f5" # Sing-Along Versions
            "bfd8eb01832d646a0a89c4deb46f8564" # Upscaled
            "dc98083864ea246d05a42df0d05f81cc" # x265 (HD)
            "712d74cd88bceb883ee32f773656b1f5" # Sing along
            "cae4ca30163749b891686f95532519bd" # Av1
            "923b6abef9b17f937fab56cfcf89e1f1" # DV

          ];
          assign_scores_to = [{ name = "Main"; }];
        }];
      };
    };
  };
}

