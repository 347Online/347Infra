{
  users = {
    groups.media = { };
    users.media = {
      group = "media";
      isNormalUser = true;
    };
  };

  services = {
    prowlarr.enable = true;
    ombi = {
      enable = true;
      port = 16329;
    };

    bazarr = {
      enable = true;
      group = "media";
    };
    jellyfin = {
      enable = true;
      group = "media";
    };
    lidarr = {
      enable = true;
      group = "media";
    };
    radarr = {
      enable = true;
      group = "media";
    };
    sonarr = {
      enable = true;
      group = "media";
    };
  };
}
