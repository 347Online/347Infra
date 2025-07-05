{
  pkgs,
  ...
}:

{
  imports = [
    ./services

    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "Aspen";
    firewall.enable = false;
  };

  time.timeZone = "America/Chicago";

  services.printing.enable = true;
  services.openssh.enable = true;

  users.users.katie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
      neovim
    ];
  };

  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      vim
      wget
      git
    ];
  };

  # DO NOT EDIT
  system.stateVersion = "24.11"; # Did you read the comment?
}
