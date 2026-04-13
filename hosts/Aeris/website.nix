{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    certs."347Online.me".extraDomainNames = [ "www.347Online.me" ];
    acceptTerms = true;
    defaults.email = "katiejanzen@347online.me";
  };

  systemd.tmpfiles.settings = {
    "10-347Online.me" = {
      "/var/www/347Online.me" = {
        d = {
          group = "github-actions";
          mode = "0755";
          user = "github-actions";
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
      "347Online.me" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/347Online.me";
      };

      "www.347Online.me" = {
        forceSSL = true;
        useACMEHost = "347Online.me";
        globalRedirect = "347Online.me";
      };

      "brain.347Online.me" = {
        forceSSL = true;
        enableACME = true;
      };

      "blog.347Online.me" = {
        forceSSL = true;
        enableACME = true;
        globalRedirect = "347Online.me/blog";
      };
    };
  };
}
