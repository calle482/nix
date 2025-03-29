{ config, pkgs, lib, ... }:

{


  imports =
    [
      ./services/qbittorrent.nix
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

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.qbittorrent-nox
    pkgs.wireguard-tools
  ];


  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "media";
    group = "media";
    logDir = "/apps/jellyfin/logs";
    cacheDir = "/tmp/jellyfin_cache";
    dataDir = "/apps/jellyfin/data";
    configDir = "/apps/jellyfin/config";
  };

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


  # Set DNS server
  networking.nameservers = [ "10.128.0.1" ];

  # Create network space
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

  # Create wg interface in wg network space
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
       ${pkgs.coreutils}/bin/mkdir -p /etc/netns/wg
       ${iproute2}/bin/ip netns exec wg ${bash}/bin/bash -c 'echo "nameserver 10.128.0.1" > /etc/netns/wg/resolv.conf'
       ${iproute2}/bin/ip netns exec wg \
         ${wireguard-tools}/bin/wg setconf wg0 /root/myVPNprovider.conf
       ${iproute2}/bin/ip -n wg link set wg0 up
       # need to set lo up as network namespace is started with lo down
       ${iproute2}/bin/ip -n wg link set lo up
       ${iproute2}/bin/ip -n wg route add default dev wg0
     '';
     ExecStop = with pkgs; writers.writeBash "wg-down" ''
       ${iproute2}/bin/ip -n wg route del default dev wg0
       ${iproute2}/bin/ip -n wg -6 route del default dev wg0
       ${iproute2}/bin/ip -n wg link del wg0
     '';
   };
  };

  # Bind services to wireguard
  systemd.services = {
    qbittorrent = {
      bindsTo = [ "netns@wg.service" ];
      requires = [ "network-online.target" "wg.service" ];
      serviceConfig.NetworkNamespacePath = [ "/var/run/netns/wg" ];
    };
    radarr = {
      bindsTo = [ "netns@wg.service" ];
      requires = [ "network-online.target" "wg.service" ];
      serviceConfig.NetworkNamespacePath = [ "/var/run/netns/wg" ];
    };
    sonarr = {
      bindsTo = [ "netns@wg.service" ];
      requires = [ "network-online.target" "wg.service" ];
      serviceConfig.NetworkNamespacePath = [ "/var/run/netns/wg" ];
    };
    prowlarr = {
      bindsTo = [ "netns@wg.service" ];
      requires = [ "network-online.target" "wg.service" ];
      serviceConfig.NetworkNamespacePath = [ "/var/run/netns/wg" ];
    };
  };

  # allowing qbittorrent & arr web access in wg namespace, a socket is necesarry
  systemd.sockets."proxy-to-qbittorrent" = {
   enable = true;
   description = "Socket for Proxy to Qbittorrent Daemon";
   listenStreams = [ "8080"];
   wantedBy = [ "sockets.target" ];
  };

  systemd.sockets."proxy-to-radarr" = {
   enable = true;
   description = "Socket for Proxy to Radarr Daemon";
   listenStreams = [ "7878" ];
   wantedBy = [ "sockets.target" ];
  };

 systemd.sockets."proxy-to-sonarr" = {
   enable = true;
   description = "Socket for Proxy to Sonarr Daemon";
   listenStreams = ["8989" ];
   wantedBy = [ "sockets.target" ];
  };

 systemd.sockets."proxy-to-prowlarr" = {
   enable = true;
   description = "Socket for Proxy to Prowlarr Daemon";
   listenStreams = [ "9696" ];
   wantedBy = [ "sockets.target" ];
  };


  # creating proxy service on socket, which forwards the same port from the root namespace to the wg namespace
  systemd.services."proxy-to-qbittorrent" = {
   enable = true;
   description = "Proxy to Qbittorrent Daemon in Wireguard Namespace";
   requires = [ "qbittorrent.service" "proxy-to-qbittorrent.socket" ];
   after = [ "qbittorrent.service" ".proxy-to-qbittorrent.socket" ];
   unitConfig = { JoinsNamespaceOf = "qbittorrent.service"; };
   serviceConfig = {
     User = "media";
     Group = "media";
     ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:8080";
     PrivateNetwork = "yes";
   };
  };

  systemd.services."proxy-to-radarr" = {
   enable = true;
   description = "Proxy to Radarr Daemon in Wireguard Namespace";
   requires = [ "radarr.service" "proxy-to-radarr.socket" ];
   after = [ "radarr.service" ".proxy-to-radarr.socket" ];
   unitConfig = { JoinsNamespaceOf = "radarr.service"; };
   serviceConfig = {
     User = "media";
     Group = "media";
     ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:7878";
     PrivateNetwork = "yes";
   };
  };

  systemd.services."proxy-to-sonarr" = {
   enable = true;
   description = "Proxy to Radarr Daemon in Wireguard Namespace";
   requires = [ "sonarr.service" "proxy-to-sonarr.socket" ];
   after = [ "sonarr.service" ".proxy-to-sonarr.socket" ];
   unitConfig = { JoinsNamespaceOf = "sonarr.service"; };
   serviceConfig = {
     User = "media";
     Group = "media";
     ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:8989";
     PrivateNetwork = "yes";
   };
  };

  systemd.services."proxy-to-prowlarr" = {
   enable = true;
   description = "Proxy to Radarr Daemon in Wireguard Namespace";
   requires = [ "prowlarr.service" "proxy-to-prowlarr.socket" ];
   after = [ "prowlarr.service" ".proxy-to-prowlarr.socket" ];
   unitConfig = { JoinsNamespaceOf = "prowlarr.service"; };
   serviceConfig = {
     User = "media";
     Group = "media";
     ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:9696";
     PrivateNetwork = "yes";
   };
  };


  environment.persistence."/persistent".directories = [
    "/apps/jellyfin"
    "/apps/radarr"
    "/apps/sonarr"
    "/apps/qbittorrent"
  ];

  # Hardening
  systemd.services.radarr = {
  serviceConfig = {
    PrivateTmp = true;
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    CapabilityBoundingSet = [];
    RestrictNamespaces = ["~user" "~pid" "~uts" "~cgroup" "~ipc"];
    ProtectHostname = true;
    LockPersonality = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    PrivateDevices = true;
    RestrictSUIDSGID = true;
    #ProtectClock = true;
    PrivateUsers = true;
    ProtectHome = true;
    #SystemCallFilter = [ "~@clock" "~@cpu-emulation" "~@debug" "~@module" "~@mount" "~@obsolete" "~@privileged" "~@raw-io" "~@reboot" "~@resources" "~@swap"];
    SystemCallFilter = [ "~@clock" "~@cpu-emulation" "~@debug" "~@mount" "~@obsolete" "~@obsolete" "~@privileged" "~@raw-io" "~@reboot" "~@swap"];
    ReadWritePaths = ["/apps/radarr"];
    ProtectKernelLogs = true;
    RestrictRealtime = true;
    SystemCallArchitectures = "native";
    ProtectProc = true;
    RemoveIPC = true;
    CapabilityBoundingSet=["CAP_SYS_PACCT" "~CAP_KILL" "~CAP_WAKE_ALARM"~"CAP_LINUX_IMMUTABLE" "~CAP_IPC_LOCK" "~CAP_BPF" "~CAP_SYS_TTY_CONFIG" "~CAP_SYS_BOOT" "~CAP_SYS_CHROOT"];
  # MemoryDenyWriteExecute = true;
  };
};

}
