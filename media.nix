{ config, pkgs, ... }:

{

  users.users.media = {
    isNormalUser = true;
    description = "User for media server related applications";
    packages = with pkgs; [];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
  };

}
