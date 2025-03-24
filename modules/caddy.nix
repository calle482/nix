{ config, pkgs, pkgs-unstable, ... }:

{

  #environment.systemPackages = with pkgs-unstable; [
  #  caddy
  #];



services.caddy = {
  enable = true;
  package = pkgs-unstable.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
    hash = "sha256-W09nFfBKd+9QEuzV3RYLeNy2CTry1Tz3Vg1U2JPNPPc=";
  };
  configFile = "./caddyfile";
};

networking.firewall.allowedTCPPorts = [ 80 443 ];



}
