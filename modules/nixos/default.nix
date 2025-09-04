{ lib, username, ... }:
{
  sops.age.keyFile = lib.mkDefault "/home/${username}/.config/sops/age/keys.txt";
  nix = {
    settings = {
      experimental-features = lib.mkDefault "nix-command flakes";
      trusted-users = lib.mkDefault [ username ];
    };
  };

  security.pam = {
    sshAgentAuth.enable = lib.mkDefault true;
    services.sudo.sshAgentAuth = lib.mkDefault true;
  };
}
