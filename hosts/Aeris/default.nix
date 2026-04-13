{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./website.nix
  ];

  networking.hostName = "Aeris";

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

  # DO NOT EDIT
  system.stateVersion = "25.05";
}
