{ options, config, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Nixos samba server";
        "server role" = "standalone server";
        "netbios name" = "nix-server";
        "security" = "user";
        "hosts allow" = "192.168.0.177 127.0.0.1 localhost";
        "guest account" = "nobody";
        "max log size" = "50";
        "passdb backend" = "tdbsam";
        "map to guest" = "bad user";
      };
      "Data" = {
        "valid users" = "benito";
        "path" = "/dpool/data";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "media";
      };
      "Media" = {
        "valid users" = "benito";
        "path" = "/dpool/media";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "media";
      };
      "Download" = {
        "valid users" = "benito";
        "path" = "/dpool/download";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "media";
      };
      "Document" = {
        "valid users" = "benito";
        "path" = "/dpool/document";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force group" = "media";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  services.cockpit = {
    enable = true;
    openFirewall = true;
  };
}
