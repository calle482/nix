{ config, pkgs, lib, sops-nix, ... }:

{
  home.packages = [
    pkgs.recyclarr
  ];

  sops.secrets."radarr/api_key" = { };
  sops.secrets."sonarr/api_key" = { };


  home.file.".config/recyclarr/secrets.yml".text = ''
    radarr_api_key: "${config.sops.secrets."radarr/api_key".path}"
    sonarr_api_key: "${config.sops.secrets."sonarr/api_key".path}"
  '';

  xdg.configFile."recyclarr/recyclarr.yml".source = ./modules/config/recyclarr.yml;
}
