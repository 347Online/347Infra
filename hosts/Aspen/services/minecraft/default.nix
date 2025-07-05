{
  pkgs,
  username,
  ...
}:
{
  users.users.${username}.extraGroups = [ "minecraft" ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      vanilla = {
        enable = true;
        package = pkgs.minecraftServers.vanilla-1_21_7;

        serverProperties = {
          spawn-protection = 0;
        };
      };
    };
  };
}
