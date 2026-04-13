{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    certs."347online.me".extraDomainNames = [
      "www.347online.me"
      "blog.347online.me"
    ];
    acceptTerms = true;
    defaults.email = "katiejanzen@347online.me";
  };

  systemd.tmpfiles.settings = {
    "10-347Online.me" = {
      "/var/www/347Online.me" = {
        d = {
          group = "github-actions";
          user = "github-actions";
          mode = "0755";
        };
      };
    };
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "347online.me" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/347Online.me";
      };

      "www.347online.me" = {
        forceSSL = true;
        useACMEHost = "347online.me";
        globalRedirect = "347online.me";
      };

      "blog.347online.me" = {
        forceSSL = true;
        useACMEHost = "347online.me";
        globalRedirect = "347online.me/blog";
      };
    };
  };
}
