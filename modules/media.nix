{ config, pkgs, ... }:

{


  imports =
    [
      ./services/qbittorrent.nix
    ];




  # creating VPN network namespace
  systemd.services."netns@" = {
   description = "%I network namespace";
   before = [ "network.target" ];
   serviceConfig = {
     Type = "oneshot";
     RemainAfterExit = true;
     ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
     ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
   };
  };


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

  ];



  # setting up wireguard interface within network namespace
  systemd.services.wg = {
   description = "wg network interface";
   bindsTo = [ "netns@wg.service" ];
   requires = [ "network-online.target" ];
   after = [ "netns@wg.service" ];
   serviceConfig = {
     Type = "oneshot";
     RemainAfterExit = true;
     ExecStart = with pkgs; writers.writeBash "wg-up" ''
       ${iproute2}/bin/ip link add wg0 type wireguard
       ${iproute2}/bin/ip link set wg0 netns wg
       ${iproute2}/bin/ip -n wg address add 10.139.184.160/32 dev wg0
       ${iproute2}/bin/ip netns exec wg \
         ${wireguard-tools}/bin/wg setconf wg0 /root/myVPNprovider.conf
       ${iproute2}/bin/ip -n wg link set wg0 up
       # need to set lo up as network namespace is started with lo down
       ${iproute2}/bin/ip -n wg link set lo up
       ${iproute2}/bin/ip -n wg route add default dev wg0
       # ${iproute2}/bin/ip -n wg -6 route add default dev wg0
     '';
     ExecStop = with pkgs; writers.writeBash "wg-down" ''
       ${iproute2}/bin/ip -n wg route del default dev wg0
       # ${iproute2}/bin/ip -n wg -6 route del default dev wg0
       ${iproute2}/bin/ip -n wg link del wg0
     '';
   };
  };

  # binding qbittorrent to VPN network namespace
  systemd.services.qbittorrent.bindsTo = [ "netns@wg.service" ];
  systemd.services.qbittorrent.requires = [ "network-online.target" "wg.service" ];
  systemd.services.qbittorrent.serviceConfig.NetworkNamespacePath = [ "/var/run/netns/wg" ];

  # allowing qbittorrent web access in network namespace, a socket is necesarry
  systemd.sockets."proxy-to-vpn" = {
   enable = true;
   description = "Socket for Proxy to Qbittorrent Daemon";
   listenStreams = [ "8080" ];
   wantedBy = [ "sockets.target" ];
  };


  # creating proxy service on socket, which forwards the same port from the root namespace to the isolated namespace
  systemd.services."proxy-to-vpn" = {
   enable = true;
   description = "Proxy to Qbittorrent Daemon in Network Namespace";
   requires = [ "qbittorrent.service" "proxy-to-vpn.socket" ];
   after = [ "qbittorrent.service" ".proxy-to-vpn.socket" ];
   unitConfig = { JoinsNamespaceOf = "qbittorrent.service"; };
   serviceConfig = {
     User = "media";
     Group = "media";
     ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:8080";
     PrivateNetwork = "yes";
   };
  };

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


}
