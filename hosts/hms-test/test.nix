{
  config,
  inputs,
  pkgs,
  ...
}:
{
  services.slskd = {
    enable = true;
    openFirewall = true;
  };
}
