{ config, pkgs, lib, sops-nix, ... }:

{
  home.username = "calle";
  home.homeDirectory = "/home/calle";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11"; # This should not be changed, keep at the version which the system was installed on

  home.sessionVariables = {
    EDITOR = "vim";
  };


  # sops
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/calle/.config/sops/age/keys.txt";
  sops.defaultSymlinkPath = "/run/user/1000/secrets";
  sops.defaultSecretsMountPoint = "/run/user/1000/secrets.d";

  imports = [
    ./modules/hyprland.nix
  ];

}
