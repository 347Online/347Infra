{
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./nginx.nix
  ];

  networking.hostName = "Astrid";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3E1Sps4U+TZUCA2vBiCVDfx60u1k9dmXwecnyhnQf6"
  ];

  # DO NOT EDIT
  system.stateVersion = "25.11";
}
