{
  self,
  inputs,
  ...
}:
{
  flake = {
    deploy = {
      remoteBuild = true;
      interactiveSudo = true;

      nodes = {
        Aeris = {
          hostname = "347online.me";
          profiles.system = {
            user = "root";
            sshUser = self.variables.defaultUsername;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.Aeris;
          };
        };
        Aspen = {
          hostname = "fatgirl.cloud";
          profiles.system = {
            user = "root";
            sshUser = self.variables.defaultUsername;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.Aspen;
          };
        };
        Astrid = {
          hostname = "192.168.4.119"; # Local-only!
          profiles.system = {
            user = "root";
            sshUser = self.variables.defaultUsername;
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.Astrid;
          };
        };
      };
    };

    # Broken
    # checks = builtins.mapAttrs (
    #   system: deployLib: deployLib.deployChecks self.deploy
    # ) inputs.deploy-rs.lib;
  };
}
