{ config, ... }:
{
  sops.secrets.wireguard-private-key.mode = "0666";

  networking.wg-quick.interfaces = {
    wg0 = {
      privateKeyFile = config.sops.secrets.wireguard-private-key.path;
      address = [ "192.168.2.5/32" ];
      dns = [ "192.168.2.1" ];

      peers = [
        {
          publicKey = "FZhZ/zhB8X34nCsYFjNDuSGqrb+OUzG7/HPyZSgsiB8=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "218.101.21.232:51820";
        }
      ];
    };
  };
}
