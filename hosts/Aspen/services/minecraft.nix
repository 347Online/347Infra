{
  pkgs,
  username,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  users.users.${username}.extraGroups = [ "minecraft" ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      vanilla = {
        enable = true;
        package = pkgs.minecraftServers.vanilla-26_2;

        serverProperties = {
          difficulty = "normal";
          enforce-whitelist = true;
          spawn-protection = 0;
          white-list = true;
        };
      };
    };
  };
}
