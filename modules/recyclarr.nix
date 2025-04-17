{ config, pkgs, lib, home-manager, ... }:

{

  environment.systemPackages = [
    pkgs.recyclarr
  ];


  home.file.".config/recyclarr/secrets.yml".text = ''
    radarr_api_key: "${config.sops.secrets."radarr/api_key".path}"
    sonarr_api_key: "${config.sops.secrets."sonarr/api_key".path}"
  '';

  xdg.configFile."recyclarr/recyclarr.yml".source = ./config/recyclarr.yml;

}
