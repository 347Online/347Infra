{ config, ... }:
{
  sops.secrets.firefox-secrets = {
    sopsFile = ./.firefox-secrets.env;
    format = "dotenv";
    key = "";
  };

  services.firefox-syncserver = {
    enable = true;
    secrets = config.sops.secrets.firefox-secrets.path;
    singleNode = {
      enable = true;
      hostname = "localhost";
      url = "http://localhost:5000";
    };
    settings.host = "0.0.0.0";
  };
}
