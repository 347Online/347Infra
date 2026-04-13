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

    obsidian-headless-src = {
      url = "github:obsidianmd/obsidian-headless/5f51535b744625ee2cf47d61f704d4d9276590b7";
      flake = false;
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
        imports = [ ./modules ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        flake.nixosConfigurations =
          let
            nixosSharedModules = [
              inputs.sops-nix.nixosModules.sops
              config.flake.nixosModules.default
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
              packages = [
                (pkgs.writeShellApplication {
                  name = "deploy-to";
                  text = ''
                    nixos-rebuild-ng switch --build-host aspen --target-host "$1" --flake . --use-substitutes --sudo --ask-sudo-password
                  '';
                })
                (pkgs.writeShellApplication {
                  name = "deploy-all";
                  text = ''
                    for x in {aspen,astrid,172.233.131.81}; do
                      nixos-rebuild-ng switch --build-host aspen --target-host "$x" --flake . --use-substitutes --sudo --ask-sudo-password
                    done
                  '';
                })
              ];
            };

            formatter = pkgs.nixfmt-tree;
          };
      }
    );
}
