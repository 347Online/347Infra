{ lib, username, ... }:
{
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys-infra.txt";
  security.pam.enableSSHAgentAuth = lib.mkDefault true;
}
