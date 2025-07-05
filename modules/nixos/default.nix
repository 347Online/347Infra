{ lib, username, ... }:
{
  security.pam.services.${username}.sshAgentAuth = lib.mkDefault true;
}
