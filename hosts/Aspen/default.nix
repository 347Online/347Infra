{
  username,
  ...
}:
{
  imports = [
    ./services

    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = ./.aspen-secrets.yaml;

  services.syncthing.guiAddress = "0.0.0.0:8384";

  environment.enableAllTerminfo = true;

  networking = {
    firewall.enable = false;
    hostName = "Aspen";
  };
  time.timeZone = "America/Chicago";

  # Enables cross-build to ARM systems
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # DO NOT EDIT
  system.stateVersion = "24.11";
}
