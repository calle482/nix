{ config, pkgs, pkgs-unstable, ... }:

{

  #environment.systemPackages = with pkgs-unstable; [
  #  caddy
  #];



services.caddy = {
  enable = true;
  package = pkgs-unstable.caddy.withPlugins {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e" ];
    hash = "sha256-AoW35l7QkXunjBzZ43IlyU3UkVXw2D4eyc1jx8xpT0U=";
  };
};

networking.firewall.allowedTCPPorts = [ 80 443 ];



}
