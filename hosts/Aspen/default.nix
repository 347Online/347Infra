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

  nix.settings.trusted-users = [ username ];

  # DO NOT EDIT
  system.stateVersion = "24.11";
}
