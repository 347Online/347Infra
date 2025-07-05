{ lib, ... }:
{
  security.pam.enableSSHAgentAuth = lib.mkDefault true;
}
