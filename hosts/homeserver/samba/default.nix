{ options, config, ... }:
{
  services.samba = {
    enable = true;
    settings.global.securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Nixos samba server";
        "server role" = "standalone server";
        "netbios name" = "nix-server";
        "security" = "user";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "guest account" = "guest";
        "max log size" = "50";
        "passdb backend" = "tdbsam";
        "map to guest" = "bad user";
      };
      "private" = {
        "valid users" = "benito";
        "comment" = "Main data share";
        "path" = "/mnt/test";
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

  services.cockpit.enable = true;

}
