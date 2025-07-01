{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      defaultUsername = "katie";
      arm-pkgs = import nixpkgs { system = "aarch64-linux"; };
    in
    {
      nixosConfigurations.Astrid = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs = arm-pkgs;
        };
        modules = [ ./hosts/Astrid ];
      };
    };
}
