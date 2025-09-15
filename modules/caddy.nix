{ config, pkgs, ... }:

{

# Secrets
sops.secrets."cloudflare/api_key" = {
  owner = "caddy";
};

  environment.systemPackages = with pkgs; [
    caddy
  ];

#sops.templates."caddy.env" = {
#  owner = "caddy";
#  content = ''
#  CF_API_TOKEN=${config.sops."cloudflare/api_token"}
#'';
#};

services.caddy = {
  enable = true;
  package = pkgs.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" "github.com/caddyserver/transform-encoder@v0.0.0-20231219065943-58ebafa572d5" ];
    hash = ["sha256-KRfi9yBB2lJZSPjy5WEF1s5JgazAOdL+3/Qo2zV0ulc="];
  };
  configFile = ./caddyfile;
};

systemd.services.caddy = {
  serviceConfig = {
    PrivateTmp = true;
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE" "CAP_DAC_READ_SEARCH"];
    RestrictNamespaces = ["~user" "~pid" "~uts" "~cgroup" "~ipc"];
    ProtectHostname = true;
    LockPersonality = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    PrivateDevices = true;
    RestrictSUIDSGID = true;
    ProtectClock = true;
    #PrivateUsers = true;
    ProtectHome = true;
    SystemCallFilter = [ "~@clock" "~@cpu-emulation" "~@debug" "~@module" "~@mount" "~@obsolete" "~@privileged" "~@raw-io" "~@reboot" "~@resources" "~@swap"];
    ProtectKernelLogs = true;
    RestrictRealtime = true;
    SystemCallArchitectures = "native";
    ProtectProc = true;
    RemoveIPC = true;
    MemoryDenyWriteExecute = true;
    ReadOnlyPaths = config.sops.secrets."cloudflare/api_key".path;
    EnvironmentFile = config.sops.secrets."cloudflare/api_key".path;
  };
};

#systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.secrets."cloudflare/api_key".path;
#systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";

networking.firewall.allowedTCPPorts = [ 80 443 ];

  environment.persistence."/persistent".directories = [
    "/var/lib/caddy"
  ];


  services.fail2ban = {
    enable = true;
    ignoreIP = ["192.168.10.0/24"];
    maxretry = 8;
    bantime-increment.enable = true;
    bantime-increment.formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
    bantime-increment.rndtime = "5m";
    jails = {
      jellyfin.settings = {
        enabled = true;
        action = ''iptables-multiport[name=HTTP, port="http,https"]'';
        filter = "caddy-access";
        logppath = "/var/log/caddy/jellyfin-access.log";
        backend = "auto";
        maxretry = 8;
        findtime = 30;
        bantime = 600;
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/caddy-access.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*"(GET|POST|OPTION).*" (4[0-9][0-9])[ \d]*$
      ignoreregex =
    '';
  };

}
