{ lib, username, ... }:
{
  sops.age.keyFile = lib.mkDefault "/home/${username}/.config/sops/age/keys.txt";

  security.pam = {
    sshAgentAuth.enable = lib.mkDefault true;
    services.sudo.sshAgentAuth = lib.mkDefault true;
  };
}
