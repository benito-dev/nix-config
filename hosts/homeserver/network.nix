{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets = {
    "wifi/saePassword" = { };
    "wifi/wpaPassword" = { };

  };
  # Network
  networking = {
    defaultGateway = {
      address = "192.168.0.1";
      interface = "br0";
    };
    hostId = "37740ce0";
    nameservers = [
      "192.168.0.240"
      "1.0.0.1"
    ];
    hostName = "homeserver";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        80
        443
        53
      ];
      allowedUDPPorts = [
        53
      ];
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
  services = {
    hostapd = {
      enable = true;
      radios."wlp11s0" = {
        band = "5g";
        channel = 36;
        countryCode = "BE";
        networks.wlp11s0 = {
          ssid = "Home";
          authentication = {
            mode = "wpa3-sae-transition";
            saePasswordsFile = config.sops.secrets."wifi/saePassword".path;
            wpaPasswordFile = config.sops.secrets."wifi/wpaPassword".path;
          };
          settings = {

            bridge = "br0";

            ieee80211ac = 1;
            ieee80211ax = 1;

            ht_capab = "[HT40+][LDPC][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][MAX-AMSDU-7935]";
            vht_capab = "[MAX-MPDU-11454][VHT160][RXLDPC][SHORT-GI-80][SHORT-GI-160][TX-STBC-2BY1][SU-BEAMFORMEE][MU-BEAMFORMEE]";

            vht_oper_chwidth = 1;
            vht_oper_centr_freq_seg0_idx = 42;

            he_oper_chwidth = 1;
            he_oper_centr_freq_seg0_idx = 42;

            he_su_beamformer = 1;
            he_su_beamformee = 1;
            he_mu_beamformer = 1;

            wmm_enabled = 1;
          };
        };
      };
    };
  };
}
