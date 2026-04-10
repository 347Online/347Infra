{
  lib,
  username,
  ...
}:

{
  sops.defaultSopsFile = ./.aspen-secrets.yaml;

  imports = [
    ./services

    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "Aspen";
    firewall.enable = false;
  };

  services.printing.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "minecraft-server"
    ];

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3E1Sps4U+TZUCA2vBiCVDfx60u1k9dmXwecnyhnQf6"
  ];

  nix.settings.trusted-users = [ username ];

  # DO NOT EDIT
  system.stateVersion = "24.11";
}
