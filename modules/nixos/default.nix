{
  pkgs,
  lib,
  username,
  ...
}:
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

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  time.timeZone = "America/Chicago";

  services.openssh.enable = true;

  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      git
      tmux
      vim
    ];
  };

  # DO NOT EDIT
  system.stateVersion = "25.11";
}
