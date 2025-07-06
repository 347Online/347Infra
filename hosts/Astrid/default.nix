{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nginx.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "Astrid";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  time.timeZone = "America/Chicago";

  users.users.katie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
	neovim
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
  ];

  services.openssh.enable = true;


  # DO NOT EDIT
  system.stateVersion = "25.11";

}

