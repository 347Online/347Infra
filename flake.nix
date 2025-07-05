{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    {
      self,
      nixpkgs,
    }@inputs:
    let
      defaultUsername = "katie";
      arm-pkgs = import nixpkgs { system = "aarch64-linux"; };
      intel-pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      nixosConfigurations.Aspen = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs = intel-pkgs;
        };
        modules = [
          {
            imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
          ./hosts/Aspen
        ];
      };
      nixosConfigurations.Astrid = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs = arm-pkgs;
        };
        modules = [ ./hosts/Astrid ];
      };
    };
}
