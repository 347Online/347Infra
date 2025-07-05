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
    in
    {
      nixosConfigurations.Aspen = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          username = defaultUsername;
        };
        modules = [
          sops-nix.nixosModules.sops

          nix-minecraft.nixosModules.minecraft-servers
          ./hosts/Aspen
        ];
      };
      nixosConfigurations.Astrid = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          username = defaultUsername;
        };
        modules = [
          sops-nix.nixosModules.sops

          ./hosts/Astrid
        ];
      };
    };
}
