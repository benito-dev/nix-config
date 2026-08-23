{
  services.homepage-dashboard.widgets = [
    {
      datetime = {
        text_size = "xl";
        format = {
          timeStyle = "short";
        };
      };
    }
    {
      openmeteo = {
        label = "Bruxelles";
        latitude = 50.85045;
        longitude = 4.34878;
        timezone = "Europe/Brussels";
        units = "metric";
        cache = 5;
        format = {
          maximumFractionDigits = 1;
        };
      };
    }
  ];
}
