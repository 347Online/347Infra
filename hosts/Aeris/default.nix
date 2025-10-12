{
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "Aeris";
  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOe2vJeqUHEDAm8PpZ7jLoYhKIEbHz2aMQc650FlbrhP"
  ];

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
  ];
}
