{ lib, ... }:
{
  services.adguardhome = {
    enable = true;
    allowDHCP = true;
    mutableSettings = false;
    settings = {
      http.address = "127.0.0.1:3000";
      users = [
        {
          name = "benito";
          password = "$2a$12$uW5UHPqRsyd33mYWOrMLu.ZBizEskXqkf67fTnJacMJvFaefiG282";
        }
      ];
      auth_attempts = 3;
      block_auth_min = 5;
      dns = {
        upstream_dns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        bootstrap_dns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        filters_update_interval = 6;
      };
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.plus.txt"
            "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
            "https://big.oisd.nl"
            "https://adaway.org/hosts.txt"
            "https://someonewhocares.org/hosts/zero/hosts"
          ];
      dhcp = {
        enabled = true;
        interface_name = "br0";
        dhcpv4 = {
          gateway_ip = "192.168.0.1";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.0.100";
          range_end = "192.168.0.150";
          lease_duration = 0;
          icmp_timeout_msec = 150;
        };
      };
    };
  };
}
