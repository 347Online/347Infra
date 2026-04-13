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

  users = {
    groups.github-actions = { };
    users = {
      ${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOe2vJeqUHEDAm8PpZ7jLoYhKIEbHz2aMQc650FlbrhP"
      ];

      github-actions = {
        group = "github-actions";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEA57BeLEFUQO7CLSjkrZzlKSLqgfviHXhMDoz/wJ3GS"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat
  ];

  nix.settings.trusted-users = [ username ];

  # DO NOT EDIT
  system.stateVersion = "25.05";
}
