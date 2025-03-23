{ config, pkgs, ... }:

{

services.caddy = {
  enable = true;
  package = pkgs.caddy-cloudflare;
  configFile = ./caddyfile;
};

networking.firewall.allowedTCPPorts = [ 80 443 ];



}
