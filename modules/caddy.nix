{ config, pkgs, pkgs-unstable, ... }:

{

  environment.systemPackages = with pkgs-unstable; [
    caddy
  ];



services.caddy = {
  enable = true;
  package = pkgs.caddy.withPlugins {
    plugins = [ "https://github.com/caddy-dns/cloudflare" ];
    hash = "sha256-F/jqR4iEsklJFycTjSaW8B/V3iTGqqGOzwYBUXxRKrc=";
  };
};

networking.firewall.allowedTCPPorts = [ 80 443 ];



}
