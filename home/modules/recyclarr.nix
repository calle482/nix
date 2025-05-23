{ config, pkgs, lib, sops-nix, ... }:

{
  home.packages = [
    pkgs.recyclarr
  ];

#   sops.secrets."radarr/api_key" = { };
#   sops.secrets."sonarr/api_key" = { };
#
#
#   sops.templates."recyclarr-secrets" = {
#     content = ''
#       radarr_api_key: ${config.sops.placeholder."radarr/api_key"}
#       sonarr_api_key: ${config.sops.placeholder."sonarr/api_key"}
#     '';
#   };
#
#
#  home.file.".config/recyclarr/secrets.yml".text = ''
#    radarr_api_key: "${config.sops.secrets."radarr/api_key".path}"
#    sonarr_api_key: "${config.sops.secrets."sonarr/api_key".path}"
#  '';

  xdg.configFile."recyclarr/recyclarr.yml".source = ./config/recyclarr.yml;
}
