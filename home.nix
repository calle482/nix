{ config, pkgs, lib, ... }:

{
  home.username = "calle";
  home.homeDirectory = "/home/calle";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11"; # This should not be changed, keep at the version which the system was installed on

  home.sessionVariables = {
    EDITOR = "vim";
  };}
