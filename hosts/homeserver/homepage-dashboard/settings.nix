# For configuration options and examples, please see:
# https://gethomepage.dev/latest/nix-env -q package-nameconfigs/settings
{
  services.homepage-dashboard.settings = {
    layout = {
      "AMonitoring" = {
        header = false;
        style = "row";
        columns = 5;
      };
      "Media" = {
        style = "row";
        columns = 4;
      };
      "Network" = {
        style = "row";
        columns = 4;
      };
    };
  };
}
