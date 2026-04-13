{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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
    flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
