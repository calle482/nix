{ config, pkgs, ... }:

{

  # Create media group
  users.groups.media = {};

  # Create media user and add to media group
  users.users.media = {
    isNormalUser = true;
    description = "User for media server related applications";
    extraGroups = [ "media" ];
    packages = with pkgs; [];
  };


  # Jellyfin packages
  environment.systemPackages.pkgs = [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
  };

}
