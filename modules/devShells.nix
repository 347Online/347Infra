{
  perSystem =
    { pkgs, lib, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages =
          let
            nixos-rebuild-ng = lib.getExe pkgs.nixos-rebuild-ng;
          in
          [
            (pkgs.writeShellApplication {
              name = "deploy-to";
              text = ''
                ${nixos-rebuild-ng} switch --build-host aspen --target-host "$1" --flake . --use-substitutes --sudo --ask-sudo-password
              '';
            })
            (pkgs.writeShellApplication {
              name = "deploy-all";
              text = ''
                for x in {aspen,astrid,347online.me}; do
                  ${nixos-rebuild-ng} switch --build-host aspen --target-host "$x" --flake . --use-substitutes --sudo --ask-sudo-password
                done
              '';
            })
          ];
      };
    };
}
