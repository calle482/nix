# configuration.nix. Example of all options that are explained below.

{ config, lib, pkgs, ... }:

{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers = {
      survival = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_4;
        dataDir = "/apps/minecraft/survival";
        serverProperties = {
          gamemode = "survival";
          difficulty = "normal";
          simulation-distance = "32";
        };
        whitelist = {/* */};
          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {
                Fabric-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/bQZpGIz0/fabric-api-0.119.2%2B1.21.4.jar";
                  sha512 = "bb8de90d5d1165ecc17a620ec24ce6946f578e1d834ddc49f85c2816a0c3ba954ec37e64f625a2f496d35ac1db85b495f978a402a62bbfcc561795de3098b5c9";
                };
              }
            );
          };
        };
      };
    };
}
