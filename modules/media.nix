{ config, pkgs, lib, ... }: let
inherit (lib) mkForce;
in {


  imports =
    [
      ./services/qbittorrent.nix
      ./services/private-wireguard.nix
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
    pkgs.systemd-resolved
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


  services.resolved = {
    enable = true;
  };

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

  # setting up wireguard interface within network namespace
  systemd.services."wg-quick@wg0" = {
    enable = true;
    description = "wg network interface";
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "netns@wg.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs; writers.writeBash "wg-up" ''${wireguard-tools}/bin/wg-quick up wg0'';
      ExecStop = with pkgs; writers.writeBash "wg-up" ''${wireguard-tools}/bin/wg-quick down wg0'';
    };
  };

  # binding qbittorrent to VPN network namespace
  systemd.services.qbittorrent.bindsTo = [ "netns@wg.service" ];
  systemd.services.qbittorrent.requires = [ "network-online.target" "wg-quick@wg0.service" ];
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



  # networking.private-wireguard.enable = true;
  # networking.private-wireguard.ips = [
  #   "10.139.184.160/32"
  # ];
  # networking.private-wireguard.dns = "10.128.0.1";
  # networking.private-wireguard.privateKeyFile = "/root/wg-private";
  # networking.private-wireguard.peers = [
  #   {
  #     publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
  #     allowedIPs = ["0.0.0.0/0" "::0/0"];
  #     endpoint = "62.102.148.206:1637";
  #     persistentKeepalive = 15;
  #   }
  # ];

  # systemd.services.qbittorrent = {
  #   bindsTo = ["wireguard-private.service"];
  #   after = ["wireguard-private.service"];
  #   serviceConfig = {
  #   NetworkNamespacePath = [ "/var/run/netns/private" ];
  #   };
  # };

  # systemd.services.qbittorrent-forwarder = {
  #   enable = true;
  #   after = ["qbittorrent.service"];
  #   bindsTo = ["qbittorrent.service"];
  #   wantedBy = ["multi-user.target"];
  #   script = ''
  #     ${pkgs.socat}/bin/socat tcp-listen:${toString 8080},fork,reuseaddr,ignoreeof exec:'${pkgs.iproute2}/bin/ip netns exec private ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:${toString 8080}"',nofork
  #   '';
  # };

}
