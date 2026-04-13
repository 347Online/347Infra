{ inputs, self, ... }:
{
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  flake.nixosConfigurations =
    let
      specialArgs = {
        inherit inputs;
        username = self.variables.defaultUsername;
      };
      nixosSharedModules = [
        inputs.sops-nix.nixosModules.sops
        self.nixosModules.default
      ];
    in
    {
      Aeris = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = nixosSharedModules ++ [
          ../hosts/Aeris
        ];
      };

      Aspen = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = nixosSharedModules ++ [
          inputs.nix-minecraft.nixosModules.minecraft-servers
          ../hosts/Aspen
        ];
      };

      Astrid = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = nixosSharedModules ++ [
          ../hosts/Astrid
        ];
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
