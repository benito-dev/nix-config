{ config, ... }:
{
  services.trilium-server = {
    enable = true;
    port = 8085;
    host = "localhost";
    dataDir = "/dpool/data/trilium";
  };
}
