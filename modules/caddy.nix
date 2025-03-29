{ config, pkgs, pkgs-unstable, ... }:

{

# Secrets
sops.secrets."cloudflare/api_key" = {
  owner = "caddy";
};

  environment.systemPackages = with pkgs-unstable; [
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
  package = pkgs-unstable.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
    hash = "sha256-W09nFfBKd+9QEuzV3RYLeNy2CTry1Tz3Vg1U2JPNPPc=";
  };
  configFile = ./caddyfile;
};

systemd.services.caddy = {
  serviceConfig = {
    PrivateTmp="yes";
    NoNewPrivileges=true;
    ProtectSystem="strict";
    CapabilityBoundingSet=C"AP_NET_BIND_SERVICE CAP_DAC_READ_SEARCH";
    RestrictNamespaces="uts ipc pid user cgroup";
    ProtectKernelTunables="yes";
    ProtectKernelModules="yes";
    ProtectControlGroups="yes";
    PrivateDevices="yes";
    RestrictSUIDSGID=true
    EnvironmentFile = config.sops.secrets."cloudflare/api_key".path;
  }
};

#systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.secrets."cloudflare/api_key".path;
#systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";

networking.firewall.allowedTCPPorts = [ 80 443 ];



}
