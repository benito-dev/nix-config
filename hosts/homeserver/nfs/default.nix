{ options, config, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /dpool/batocera  192.168.0.0/24(rw,sync,no_subtree_check,no_root_squash)
    '';
  };
}
