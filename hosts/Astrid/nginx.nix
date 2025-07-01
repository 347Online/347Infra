{ config, ... }:
{
  sops.secrets.adguard-home-passwd-file.mode = "0666";

  security.acme = {
    certs."fatgirl.cloud".extraDomainNames = [ "www.fatgirl.cloud" ];
    acceptTerms = true;
    defaults = {
      webroot = "/var/www/fatgirl";
      email = "katiejanzen@347online.me";
    };
  };

  users.users = {
    nginx.extraGroups = [ "acme" ];
    acme.extraGroups = [ "nginx" ];
    katie.extraGroups = [ "nginx" ];
  };

  services.nginx = {
    enable = true;

    enableReload = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig =
      # nginx
      ''
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }

        add_header Strict-Transport-Security $hsts_header;
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header Referrer-Policy 'same-origin';
        add_header Permissions-Policy "geolocation=(), microphone=()";
        # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

    virtualHosts =
      let
        base = locations: {
          inherit locations;

          forceSSL = true;
          enableACME = true;
        };
        proxy =
          {
            ip ? "127.0.0.1",
            port ? null,
            urlpath ? null,
          }:
          base {
            "/".proxyPass = "http://${ip}${if port != null then ":${toString port}" else ""}${
              if urlpath != null then "/${urlpath}" else ""
            }";
          };
      in
      {
        "fatgirl.cloud" = {
          default = true;
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            root = "/var/www/fatgirl";
            extraConfig =
              # nginx
              ''
                default_type text/html;
              '';
          };
        };
        "www.fatgirl.cloud" = {
          useACMEHost = "fatgirl.cloud";
          forceSSL = true;
          globalRedirect = "fatgirl.cloud";
        };
        "social.fatgirl.cloud" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            recommendedProxySettings = true;
            proxyWebsockets = true;
            proxyPass = "http://192.168.4.55:3475";
          };
        };
        "dns.fatgirl.cloud" =
          proxy {
            ip = "192.168.4.55";
            port = 41419;
          }
          // {
            basicAuthFile = config.sops.secrets.adguard-home-passwd-file.path;
            extraConfig =
              # nginx
              ''
                proxy_set_header Host $host;
              '';
          };
        "watch.fatgirl.cloud" = proxy {
          ip = "192.168.4.55";
          port = 2294;
        };
        "sync.fatgirl.cloud" = proxy {
          ip = "192.168.4.55";
          port = 8384;
        };
        "firefox.fatgirl.cloud" = proxy {
          ip = "192.168.4.55";
          port = 5000;
        };
        "rss.fatgirl.cloud" = proxy {
          ip = "192.168.4.55";
        };
        "transmission.fatgirl.cloud" = proxy {
          ip = "192.168.4.55";
          port = 9091;
        };
        "plex.fatgirl.cloud" =
          proxy {
            ip = "192.168.4.55";
            port = 32400;
          }
          // {
            sslCertificate = "/https-cert.pem";
            sslCertificateKey = "/https-key.pem";
            extraConfig =
              # nginx
              ''
                #Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
                send_timeout 100m;

                # Why this is important: https://blog.cloudflare.com/ocsp-stapling-how-cloudflare-just-made-ssl-30/
                ssl_stapling on;
                ssl_stapling_verify on;

                ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
                ssl_prefer_server_ciphers on;
                #Intentionally not hardened for security for player support and encryption video streams has a lot of overhead with something like AES-256-GCM-SHA384.
                ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';

                # Forward real ip and host to Plex
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header Host $server_addr;
                proxy_set_header Referer $server_addr;
                proxy_set_header Origin $server_addr;

                # Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off.
                gzip on;
                gzip_vary on;
                gzip_min_length 1000;
                gzip_proxied any;
                gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
                gzip_disable "MSIE [1-6]\.";

                # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
                # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
                client_max_body_size 100M;

                # Plex headers
                proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
                proxy_set_header X-Plex-Device $http_x_plex_device;
                proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
                proxy_set_header X-Plex-Platform $http_x_plex_platform;
                proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
                proxy_set_header X-Plex-Product $http_x_plex_product;
                proxy_set_header X-Plex-Token $http_x_plex_token;
                proxy_set_header X-Plex-Version $http_x_plex_version;
                proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
                proxy_set_header X-Plex-Provides $http_x_plex_provides;
                proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
                proxy_set_header X-Plex-Model $http_x_plex_model;

                # Websockets
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";

                # Buffering off send to the client as soon as the data is received from Plex.
                proxy_redirect off;
                proxy_buffering off;
              '';
          };
      };
  };
}
