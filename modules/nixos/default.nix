{
  flake.nixosModules = rec {
    infra =
      {
        pkgs,
        lib,
        username,
        ...
      }:
      {
        sops.age.keyFile = lib.mkDefault "/home/${username}/.config/sops/age/keys.txt";

        nix = {
          settings = {
            experimental-features = "nix-command flakes";
            trusted-users = [ username ];
          };
        };

        security.pam = {
          sshAgentAuth.enable = true;
          services.sudo.sshAgentAuth = true;
        };

        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };

        time.timeZone = "America/Chicago";

        services.openssh.enable = true;

        environment = {
          enableAllTerminfo = true;
          systemPackages = with pkgs; [
            git
            tmux
            vim
          ];
        };
      };

    default = infra;
  };
}
