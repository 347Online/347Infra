{
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
    };
}
