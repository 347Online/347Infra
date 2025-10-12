{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./nginx.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "Astrid";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # DO NOT EDIT
  system.stateVersion = "25.11";
}
