{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
    {
      self,
      nixpkgs,
      nix-minecraft,
      sops-nix,
    }@inputs:
    let
      defaultUsername = "katie";
      nixosSharedModules = [
        ./modules/nixos
        sops-nix.nixosModules.sops
      ];
      specialArgs = {
        inherit inputs;
        username = defaultUsername;
      };
    in
    {
      nixosConfigurations = {
        Aeris = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = nixosSharedModules ++ [
            ./hosts/Aeris
          ];
        };

        Aspen = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = nixosSharedModules ++ [
            nix-minecraft.nixosModules.minecraft-servers
            ./hosts/Aspen
          ];
        };

        Astrid = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = nixosSharedModules ++ [
            ./hosts/Astrid
          ];
        };
      };
    };
}
