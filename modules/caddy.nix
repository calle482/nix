{ config, pkgs, ... }:

{

nixpkgs.overlays = [
  (import ../overlays/caddy.nix)
];

environment.systemPackages = with pkgs; [
  caddy-cloudflare
];


services.caddy = {
  enable = true;
  package = pkgs.caddy-cloudflare;
  configFile = ./caddyfile;
};

networking.firewall.allowedTCPPorts = [ 80 443 ];



}
