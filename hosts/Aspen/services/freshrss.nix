{ config, username, ... }:
{
  sops.secrets.freshrss-passwd.mode = "0666";

  services.freshrss = {
    enable = true;

    baseUrl = "http://192.168.4.56";

    defaultUser = username;
    passwordFile = config.sops.secrets.freshrss-passwd.path;
  };
}
