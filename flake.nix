{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      defaultUsername = "katie";

      specialArgs = {
        inherit inputs;
        username = defaultUsername;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }:
      {
        imports = [ ./modules/nixos ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        flake.nixosConfigurations =
          let
            nixosSharedModules = [
              config.flake.nixosModules.infra
              inputs.sops-nix.nixosModules.sops
            ];
          in
          {
            Aeris = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = nixosSharedModules ++ [
                ./hosts/Aeris
              ];
            };

            Aspen = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = nixosSharedModules ++ [
                inputs.nix-minecraft.nixosModules.minecraft-servers
                ./hosts/Aspen
              ];
            };

            Astrid = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = nixosSharedModules ++ [
                ./hosts/Astrid
              ];
            };
          };

        perSystem =
          { pkgs, ... }:
          {
            devShells.default = pkgs.mkShell {
              buildInputs = [ pkgs.nixos-rebuild-ng ];
            };

            formatter = pkgs.nixfmt-tree;
          };
      }
    );
}
