{ config, pkgs, ... }:

{

  # Create media group
  users.groups.media = {};

  # Create media user and add to media group
  users.users.media = {
    isNormalUser = true;
    description = "User for media server related applications";
    extraGroups = [ "media" "jellyfin"];
    packages = with pkgs; [];
  };


  # Jellyfin packages
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
    logDir = "/apps/jellyfin/logs";
    cacheDir = "/apps/jellyfin/cache";
    dataDir = "/apps/jellyfin/data";
    configDir = "/apps/jellyfin/config";
  };

  # Radarr service
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
    dataDir = "/apps/radarr/data";
};


}
