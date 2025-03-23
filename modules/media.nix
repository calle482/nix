{ config, pkgs, lib, ... }: let
inherit (lib) mkForce;
in {


  imports =
    [
      ./services/qbittorrent.nix
      ./services/private-wireguard.nix
      ../packages/netns-exec/default.nix
    ];

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
    pkgs.qbittorrent-nox
    pkgs.wireguard-tools
    pkgs.socat
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

  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
    dataDir = "/apps/sonarr/data";
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.bazarr = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
  };

  #services.autobrr = {
  #  enable = true;
  #  openFirewall =  true;
  #};

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
    torrentingPort = 1234;
    profileDir = "/apps/qbittorrent";
  };

  networking.private-wireguard.enable = true;
  networking.private-wireguard.ips = [
    "10.139.184.160/32"
    "fd7d:76ee:e68f:a993:e343:5067:2ee2:1a23/128"
  ];
  networking.private-wireguard.privateKeyFile = "/root/wg-private";
  networking.private-wireguard.peers = [
    {
      publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
      allowedIPs = ["0.0.0.0/0" "::0/0"];
      endpoint = "62.102.148.206:1637";
      persistentKeepalive = 15;
    }
  ];

  systemd.services.qbittorrent = {
    bindsTo = ["wireguard-private.service"];
    after = ["wireguard-private.service"];
    serviceConfig = {
      ExecStart = mkForce "/run/wrappers/bin/netns-exec private ${pkgs.qbittorrent}/bin/qbittorrent";
    };
  };

  systemd.services.qbittorrent-forwarder = {
    enable = true;
    after = ["qbittorrent.service"];
    bindsTo = ["qbittorrent.service"];
    wantedBy = ["multi-user.target"];
    script = ''
      ${pkgs.socat}/bin/socat tcp-listen:8080,fork,reuseaddr,bind=127.0.0.1  exec:'/run/wrappers/bin/netns-exec private ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:8080"',nofork
    '';
  };

}
