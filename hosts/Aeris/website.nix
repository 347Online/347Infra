{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "katiejanzen@347online.me";
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."347Online.me" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/347Online.me";
    };
  };

}
