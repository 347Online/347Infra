{
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  users.users.${username}.extraGroups = [ "minecraft" ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      vanilla = {
        enable = true;
        package = pkgs.minecraftServers.vanilla-1_21_4;

        serverProperties = {
          spawn-protection = 0;
        };
      };
    };
  };
}
